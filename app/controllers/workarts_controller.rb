require 'base64'
require 'httparty'
require 'net/http'
require 'json'
require "open-uri"
require "openai"

class WorkartsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  before_action :set_workart, only: :show
  before_action :set_user_workart, only: :show

  def index
    # Récupère toutes les œuvres
    @workarts = Workart.all
    # The `geocoded` scope filters only workarts with coordinates
    @markers = @workarts.select { |workart| current_user.likes?(workart) }.map do |workart|
      {
        imageUrl: workart.image_url,
        title: workart.workart_title,
        address: workart.address,
        lat: workart.latitude,
        lng: workart.longitude,
        idworkart: workart.id
      }
    end

    # Récupère toutes les œuvres avec leur nombre total de likes pour la liste
    @workarts_with_likes = Workart
    .left_joins(:user_workarts) # On inclut toutes les œuvres, même celles sans likes
    .select('workarts.id, workarts.image_url, workarts.workart_title, COUNT(user_workarts.id) AS likes_count')
    .group('workarts.id') # Regroupe les résultats par l'ID de l'œuvre

  # Crée un tableau avec les œuvres et leur nombre total de likes
  @workarts_with_likes = @workarts_with_likes.map do |workart|
    {
      id: workart.id,
      image_url: workart.image_url,
      workart_title: workart.workart_title,
      likes_count: workart.likes_count, # Si aucune like n'est trouvé, on met 0
      show_url: workart_path(workart)
    }
end
  end



def show
  @workart = Workart.find(params[:id])

  if Rails.env.local?
    @audio_paths = {short: "20250312190552.mp3", middle: "20250312182513.mp3", long: "20250312185215.mp3" }

  else

    @audio_paths = {}

    puts "Description courte: #{@workart.description_short.present? ? 'présente' : 'absente'}"
    puts "Description moyenne: #{@workart.description_middle.present? ? 'présente' : 'absente'}"
    puts "Description longue: #{@workart.description_long.present? ? 'présente' : 'absente'}"

    if @workart.description_short.present?
      short_source_path = Rails.cache.fetch('audio_file_short', TextToSpeechGeneratorService.call(@workart.description_short))
      if short_source_path.present?
        short_filename = "workart_#{@workart.id}_short_#{Time.now.to_i}.mp3"
        short_public_path = Rails.root.join('public', 'audios', short_filename)
        FileUtils.mkdir_p(File.dirname(short_public_path))
        FileUtils.cp(short_source_path, short_public_path)
        audio_paths[:short] = "/audios/#{short_filename}"
        puts "Audio court généré: #{short_public_path}"
      end
    end

    if @workart.description_middle.present?
      middle_source_path = Rails.cache.fetch('audio_file_middle', TextToSpeechGeneratorService.call(@workart.description_middle))
      if middle_source_path.present?
        middle_filename = "workart_#{@workart.id}_middle_#{Time.now.to_i}.mp3"
        middle_public_path = Rails.root.join('public', 'audios', middle_filename)
        FileUtils.mkdir_p(File.dirname(middle_public_path))
        FileUtils.cp(middle_source_path, middle_public_path)
        audio_paths[:middle] = "/audios/#{middle_filename}"
        puts "Audio middle généré: #{middle_public_path}"
      end
    end

    if @workart.description_long.present?
      long_source_path = Rails.cache.fetch('audio_file_long', TextToSpeechGeneratorService.call(@workart.description_long))
      if long_source_path.present?
        long_filename = "workart_#{@workart.id}_long_#{Time.now.to_i}.mp3"
        long_public_path = Rails.root.join('public', 'audios', long_filename)
        FileUtils.mkdir_p(File.dirname(long_public_path))
        FileUtils.cp(long_source_path, long_public_path)
        audio_paths[:long] = "/audios/#{long_filename}"
        puts "Audio long généré: #{long_public_path}"
      end
    end

    puts "Chemins audio générés: #{audio_paths.inspect}"

    @audio_paths = audio_paths

  end

end

def schedule_email
  recipient = params[:recipient]
  subject = params[:subject]
  content = params[:content]
  send_at = Time.parse(params[:send_at])

  # Vérifiez que la date est dans le futur
  if send_at > Time.current
    # ScheduledEmailJob.set(wait_until: send_at).perform_later(recipient, subject, content)
    redirect_to @your_resource, notice: "Email programmé pour #{send_at.strftime('%d/%m/%Y à %H:%M')}"
  else
    redirect_to @your_resource, alert: "La date doit être dans le futur"
  end
end

def scan
  base64_string = params[:image_data]
  client = OpenAI::Client.new

  messages = [
    { type: "text", text: prompt },
    { type: "image_url", image_url: { url: base64_string } }
  ]

  begin
    response = client.chat(
      parameters: {
        model: "gpt-4-turbo",
        messages: [{ role: "user", content: messages }],
        temperature: 0,
      }
    )

    content = response['choices'][0]['message']['content']
    result = JSON.parse(content, object_class: OpenStruct)

    # si ce n'est pas une œuvre d'art, inutile de valider le reste
    if result.is_artwork == false
      return redirect_to root_path(alert: true)
    end

    # sinon, vérifier que le résultat est bien formaté
    unless valid_openai_result?(result)
      return redirect_to root_path(ai_error: true)
    end

    if result.is_artwork
      # création / redirection
      @workart = Workart.find_or_create_by(workart_title: result.title) do |workart|
        workart.image_url = workart_picture(result.title, result.artwork_authors[0])
        workart.description_short = result.description_short
        workart.description_middle = result.description_middle
        workart.description_long = result.description_long
        workart.primary_artist = result.artwork_authors[0]
        workart.address = result.address
        workart.latitude = result.latitude
        workart.longitude = result.longitude
      end

      if @workart.nil? || !@workart.persisted?
        return redirect_to root_path(ai_error: true)
      end

      redirect_to workart_path(@workart)
    else
      redirect_to root_path(alert: true)
    end

  rescue JSON::ParserError, OpenAI::Error, Faraday::BadRequestError => e
    redirect_to root_path(ai_error: true)
  end
end

  private

    def set_workart
      @workart = Workart.find(params[:id])
    end

    def set_user_workart
      @user_workart = UserWorkart.find_by(user: current_user, workart: @workart, liked: true)
    end

    def prompt
      <<-TEXT
        You are an AI assistant specialized in identifying artworks. Given an image, your task is to analyze it and return detailed information in **valid JSON format only**. Do not include any extra text, explanations, Markdown formatting, code fences, or escape characters.

        Your JSON object must include exactly the following keys:

        - **"is_artwork"**: boolean
          → `true` if the image depicts an artwork (painting, sculpture, monument, etc.), `false` otherwise.

        - **"title"**: string or null
          → The official English name of the artwork, or `null` if not found.

        - **"artwork_authors"**: array of strings
          → A list of artist names in the format `"First name Last name"`. If unknown, return an empty array.

        - **"description_short"**: string
          → A concise historical and artistic description (350-500 characters). Include the artist’s name, creation period, and notable artistic techniques or themes.
          **Ensure the text is visually well-structured and easy to read.**

        - **"description_middle"**: string
          → A casual yet informative description emphasizing the artwork’s significance, techniques, and impact (550-775 characters).
          **Ensure the text is visually well-structured for readability.**

        - **"description_long"**: string
          → A storytelling-style description that immerses the reader in the historical and artistic context (900-1000 characters).
          **Ensure a visually structured text to make it easy to read.**

        - **"address"**: string or null
          → The official exhibition location of the artwork (museum, city, country). If unknown, return `null`.

        - **"latitude"**: number or null
          → The geographic latitude of the exhibition location. If unknown, return `null`.

        - **"longitude"**: number or null
          → The geographic longitude of the exhibition location. If unknown, return `null`.

        **Strict Instructions for "image_url":**
        1. **The image must come only from official and reliable sources** such as:
          - **Wikimedia Commons** (https://commons.wikimedia.org)
          - **Artsy** (https://www.artsy.net)
          - **Official museum websites** (e.g., Louvre, MoMA, MET, Rijksmuseum, etc.)
        2. **Before returning the URL, verify that it is active and directly accessible as an image (.jpg or .png).**
        3. **The URL must point directly to an image file, not to a webpage.** Avoid links that require redirection, login, or API requests.
        4. **If no valid image URL is found from the trusted sources, return `null`.**

        ---

        **Strict Instructions:**
        1. **Return only a single valid JSON object with the specified keys.**
        2. **Do not output any extra text, formatting markers, or explanations.**
        3. **Ensure all string values use double quotes and adhere strictly to JSON syntax.**
        4. **The descriptions must strictly conform to the character limits provided.**
        5. **Ensure each description is visually structured with line breaks to improve readability.**
        6. **If any required information is unknown, return `null` or an empty array as appropriate.**
        7. **For the "image_url", prioritize sources in the order of Wikimedia, Artsy, and official museum websites. If none are available, return `null`.**

        Your entire response must be exactly **one valid JSON object** with no additional content.
      TEXT
    end

    def workart_picture(title, author)
      # 1️⃣ Essayer Wikimedia en priorité
      wiki_url = "https://en.wikipedia.org/w/api.php"
      wiki_params = {
        action: "query",
        titles: title,
        prop: "pageimages",
        pithumbsize: 1000,
        format: "json"
      }

      wiki_uri = URI(wiki_url)
      wiki_uri.query = URI.encode_www_form(wiki_params)
      wiki_response = Net::HTTP.get(wiki_uri)
      wiki_json = JSON.parse(wiki_response)

      wiki_page = wiki_json.dig("query", "pages")&.values&.first
      wiki_image_url = wiki_page&.dig("thumbnail", "source")

      return wiki_image_url if wiki_image_url # ✅ Image trouvée sur Wikimedia

      # 2️⃣ Fallback : Chercher l'artiste sur Artsy
      artist_url = "https://api.artsy.net/api/artists?term=#{URI.encode_www_form_component(author)}"
      artist_uri = URI(artist_url)
      artist_request = Net::HTTP::Get.new(artist_uri)
      artist_request["X-Xapp-Token"] = ENV["ARTSY_API_TOKEN"]

      artist_response = Net::HTTP.start(artist_uri.host, artist_uri.port, use_ssl: true) { |http| http.request(artist_request) }
      artist_json = JSON.parse(artist_response.body)

      artist = artist_json.dig("_embedded", "artists")&.find { |a| normalize(a["name"]) == normalize(author) }
      return "No image found" unless artist # ❌ Aucun artiste trouvé sur Artsy

      artist_id = artist["id"]

      # 3️⃣ Chercher l’œuvre sur Artsy
      artwork_url = "https://api.artsy.net/api/artworks?artist_id=#{artist_id}"
      artwork_uri = URI(artwork_url)
      artwork_request = Net::HTTP::Get.new(artwork_uri)
      artwork_request["X-Xapp-Token"] = ENV["ARTSY_API_TOKEN"]

      artwork_response = Net::HTTP.start(artwork_uri.host, artwork_uri.port, use_ssl: true) { |http| http.request(artwork_request) }
      artwork_json = JSON.parse(artwork_response.body)

      artwork = artwork_json.dig("_embedded", "artworks")&.find { |art| normalize(art["title"]) == normalize(title) }
      return "No image found" unless artwork # ❌ Aucun artwork correspondant trouvé

      # 4️⃣ Utiliser **toujours** la version "large" pour l'image
      artsy_image_url = artwork["_links"]["image"]["href"].gsub("{image_version}", "large")

      return artsy_image_url || "No image found"
    end

    # 🔹 Fonction de normalisation (supprime les majuscules, espaces superflus et accents)
    def normalize(text)
      return "" if text.nil?
      text.downcase.strip.gsub(/[^\w\s]/, '')
    end

    def valid_openai_result?(result)
    required_keys = %i[
      is_artwork title artwork_authors description_short
      description_middle description_long address latitude longitude
    ]

    result_hash = result.to_h

    # Vérifie que toutes les clés sont présentes
    return false unless required_keys.all? { |key| result_hash.key?(key) }

    # Vérifie les types
    result.is_artwork.in?([true, false]) &&
      result.title.is_a?(String) &&
      result.artwork_authors.is_a?(Array) &&
      result.description_short.is_a?(String) &&
      result.description_middle.is_a?(String) &&
      result.description_long.is_a?(String) &&
      (result.address.is_a?(String) || result.address.nil?) &&
      (result.latitude.is_a?(Numeric) || result.latitude.nil?) &&
      (result.longitude.is_a?(Numeric) || result.longitude.nil?)
  end
end
