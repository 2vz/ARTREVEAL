require 'base64'
require 'httparty'

class WorkartsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_workart, only: :show
  before_action :set_user_workart, only: :show

  # GET /workarts or /workarts.json
  def index
    @workarts = Workart.all
    # The `geocoded` scope filters only workarts with coordinates
    @markers = @workarts.select { |workart| current_user.likes?(workart) }.map do |workart|
      {
        name: workart.workart_title,
        address: workart.address,
        lat: workart.latitude,
        lng: workart.longitude
      }
    end
  end

  # GET /workarts/1 or /workarts/1.json
  def show
  end

  def scan
    base64_string = params[:image_data]
    client = OpenAI::Client.new
    messages = [
      {
        "type": "text",
        "text": prompt,
        },
      {
        "type": "image_url",
        "image_url": {
          "url": base64_string
        },
      }
    ]
    response = client.chat(
      parameters: {
        model: "gpt-4-turbo",
        messages: [{ role: "user", content: messages }],
        temperature: 0,
      }
    )
    content = response['choices'][0]['message']['content']

    result = JSON.parse(content, object_class: OpenStruct)

    if (result.is_artwork)
      @workart = Workart.find_or_create_by(workart_title: result.title) do |workart|
        workart.image_url = result.image_url
        workart.description_short = result.description_short
        workart.description_middle = result.description_middle
        workart.description_long = result.description_long
        workart.primary_artist = result.artwork_authors[0]
        workart.address = result.address
        workart.latitude = result.latitude
        workart.longitude = result.longitude
      end
    end

    redirect_to workart_path(@workart)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
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

- **"image_url"**: string  
  → A **verified working URL** linking to a high-quality image (JPG or PNG) of the official artwork.  

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
      token = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IiIsInN1YmplY3RfYXBwbGljYXRpb24iOiIzMmIyNmVlZC1lZDA5LTRiNmItOTk1Zi1mZmEwN2YwNmQxNTQiLCJleHAiOjE3NDIwNTM0NTgsImlhdCI6MTc0MTQ0ODY1OCwiYXVkIjoiMzJiMjZlZWQtZWQwOS00YjZiLTk5NWYtZmZhMDdmMDZkMTU0IiwiaXNzIjoiR3Jhdml0eSIsImp0aSI6IjY3Y2M2NWQyMWIwYWRiMDAxMmZiODIxOSJ9.jlaXdKESkOv5sWN14KjYCqETTIaWMc_oAHfDyJqSdso"

      def fetch_best_artwork(query, author, token)
        search_url = "https://api.artsy.net/api/search?q=#{CGI.escape(query)}"
        response = HTTParty.get(search_url, headers: { "X-XAPP-Token" => token })
        return nil unless response.success?
    
        results = response.parsed_response.dig("_embedded", "results")
        return nil if results.nil? || results.empty?
    
        # Trier les résultats pour trouver l’œuvre officielle
        sorted_results = results.select { |res|
          res["type"] == "artwork"
        }.sort_by { |res|
          # Prioriser les titres exacts + artistes correspondants
          score = 0
          score += 3 if res["title"].casecmp?(query) # Exact match
          score += 2 if res["title"].downcase.include?(query.downcase) # Contient le titre
          score += 1 if res["title"].split.any? { |word| query.downcase.include?(word.downcase) } # Partage des mots clés
          score
        }.reverse # Le plus pertinent en premier
    
        # Vérifier si l’artiste correspond
        sorted_results.each do |result|
          artwork_url = result.dig("_links", "self", "href")
          next unless artwork_url
    
          artwork_data = HTTParty.get(artwork_url, headers: { "X-XAPP-Token" => token }).parsed_response
          artist_url = artwork_data.dig("_links", "artists", "href")
    
          if artist_url
            artist_response = HTTParty.get(artist_url, headers: { "X-XAPP-Token" => token })
            artists = artist_response.parsed_response.dig("_embedded", "artists")
            if artists&.any? { |artist| artist["name"].casecmp?(author) }
              return artwork_url # On a trouvé la bonne œuvre !
            end
          end
        end
    
        nil # Si aucun match parfait n'est trouvé
      end
    
      # 1️⃣ Essayer d’abord avec le titre complet
      artwork_url = fetch_best_artwork(title, author, token)
    
      # 2️⃣ Si aucun résultat précis, essayer une recherche plus large avec seulement l’artiste
      if artwork_url.nil?
        artwork_url = fetch_best_artwork(author, "", token)
      end
    
      return nil unless artwork_url
    
      # 3️⃣ Fetch l'URL de l'œuvre et récupérer l'image officielle
      image_url = HTTParty.get(artwork_url, headers: { "X-XAPP-Token" => token })
                           .parsed_response.dig("_links", "image", "href")
                           &.gsub("{image_version}", "large")
    
      return image_url
    end
end
