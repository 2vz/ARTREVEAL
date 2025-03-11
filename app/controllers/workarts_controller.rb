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
        workart.image_url = workart_picture(result.title, result.artwork_authors[0])
        workart.description_short = result.description_short
        workart.description_middle = result.description_middle
        workart.description_long = result.description_long
        workart.primary_artist = result.artwork_authors[0]
        workart.address = result.address
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

        - "is_artwork": boolean  
          → true if the image depicts an artwork (painting, sculpture, monument, etc.), false otherwise.

        - "title": string or null  
          → The official English name of the artwork, or null if not found.

        - "artwork_authors": array of strings  
          → A list of artist names in the format "First name Last name". If unknown, return an empty array.

        - "description_short": string  
          → A concise historical and artistic description (350-500 characters). Include the artist’s name, creation period, and notable artistic techniques or themes.  
          Example: "Peinte entre 1503 et 1519 par Léonard de Vinci (1452–1519), la Joconde est un chef-d'œuvre de la Renaissance italienne. Avec son célèbre sourire énigmatique et son regard captivant, cette œuvre incarne l'art du sfumato, une technique qui adoucit les transitions entre ombre et lumière. Commandée pour représenter Lisa Gherardini, l'épouse d’un marchand florentin, elle intrigue depuis des siècles. Anecdote : le tableau a été volé en 1911 et retrouvé deux ans plus tard, renforçant sa légende."

        - "description_middle": string  
          → A casual yet informative description emphasizing the artwork’s significance, techniques, and impact (550-775 characters).  
          Example: "La Joconde, peinte entre 1503 et 1519 par Léonard de Vinci (1452–1519), est bien plus qu’un simple portrait : c’est une révolution artistique. Léonard, génie de la Renaissance, a utilisé la technique du sfumato pour donner vie à Lisa Gherardini, une femme florentine à l’aura mystérieuse. Ce tableau, aujourd’hui exposé au Louvre, est rempli de symboles : son sourire énigmatique semble à la fois cacher et révéler ses pensées. Certains y voient un idéal de beauté, d’autres un message sur la complexité humaine. La Joconde, volée en 1911, a captivé l’imagination du monde entier et est devenue une icône de l’art. On raconte même que Napoléon l’aurait exposée dans sa chambre. À travers ce sourire, Léonard nous invite à explorer le mystère et la beauté de l’âme humaine."

        - "description_long": string  
          → A storytelling-style description that immerses the reader in the historical and artistic context (900-1000 characters).  
          Example: "Imagine Florence, au début des années 1500. Lisa Gherardini, une femme de la haute société florentine, s’assied dans l’atelier de Léonard de Vinci. Devant elle, le maître, né en 1452 à Vinci, en Toscane, et mort en 1519 en France, cherche à capturer non seulement son visage, mais son essence. Ce sourire ? Léonard l’a perfectionné pendant des années, utilisant le sfumato pour créer cette douce ambiguïté entre lumière et ombre. Peinte entre 1503 et 1519, la Joconde est devenue une œuvre mythique, un miroir de l’âme humaine. Pourquoi Lisa sourit-elle ? Ce mystère traverse les siècles. Mais ce tableau a aussi son aventure : en 1911, il a été volé au Louvre. L'œuvre voyage en Italie avant d’être retrouvée, et son absence enflamme les passions. Depuis, la Joconde, symbole de l’élégance et du mystère, semble nous rappeler que certaines énigmes n’ont pas besoin de réponse : elles existent pour être admirées."

        - "address": string or null  
          → The official exhibition location of the artwork (museum, city, country). For example, "Musée du Louvre, Paris, France". If unknown, return null.

        **Strict Instructions:**
        1. Return only a single valid JSON object with the keys specified above.
        2. Do not output any extra text, formatting markers, or explanations.
        3. Ensure all string values use double quotes and that the JSON adheres strictly to JSON syntax.
        4. The descriptions must strictly conform to the character limits provided.

        Your entire response must be exactly one valid JSON object, with no additional content.
      TEXT
    end

    def workart_picture(title, author)
      query = "#{title} #{author}" # Remplace par une variable dynamique si nécessaire
      token = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IiIsInN1YmplY3RfYXBwbGljYXRpb24iOiIzMmIyNmVlZC1lZDA5LTRiNmItOTk1Zi1mZmEwN2YwNmQxNTQiLCJleHAiOjE3NDIwNTM0NTgsImlhdCI6MTc0MTQ0ODY1OCwiYXVkIjoiMzJiMjZlZWQtZWQwOS00YjZiLTk5NWYtZmZhMDdmMDZkMTU0IiwiaXNzIjoiR3Jhdml0eSIsImp0aSI6IjY3Y2M2NWQyMWIwYWRiMDAxMmZiODIxOSJ9.jlaXdKESkOv5sWN14KjYCqETTIaWMc_oAHfDyJqSdso"

      url = "https://api.artsy.net/api/search?q=#{CGI.escape(query)}"
      
      response = HTTParty.get(url, headers: { "X-XAPP-Token" => token })

      if response.success?
        first_result = response.parsed_response["_embedded"]["results"].first
        if first_result
          thumbnail_url = first_result.dig("_links", "thumbnail", "href")
          return thumbnail_url.gsub("square", "large") if thumbnail_url
        end
      end
      nil
    end
end
