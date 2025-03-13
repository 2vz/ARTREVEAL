class WorkartsController < ApplicationController
  before_action :set_workart, only: :show
  before_action :set_user_workart, only: :show
  # GET /workarts or /workarts.json
  def index
    @workarts = Workart.all
    # The `geocoded` scope filters only workarts with coordinates
    @markers = @workarts.select { |workart| current_user.likes?(workart) }.map do |workart|
      {
        imageUrl: workart.image_url,
        name: workart.workart_title,
        address: workart.address,
        lat: workart.latitude,
        lng: workart.longitude,

      }
    end
  end

  # GET /workarts/1 or /workarts/1.json
# app/controllers/workarts_controller.rb
# app/controllers/workarts_controller.rb
# def show
#   @workart = Workart.find(params[:id])
#   @audio_path = TextToSpeechGeneratorService.call(@workart.description_long)
# end

def show
  # @workart = Workart.find(params[:id])

  # audio_paths = {}

  # puts "Description courte: #{@workart.description_short.present? ? 'présente' : 'absente'}"
  # puts "Description moyenne: #{@workart.description_middle.present? ? 'présente' : 'absente'}"
  # puts "Description longue: #{@workart.description_long.present? ? 'présente' : 'absente'}"

  # if @workart.description_short.present?
  #   short_source_path = TextToSpeechGeneratorService.call(@workart.description_short)
  #   if short_source_path.present?
  #     short_filename = "workart_#{@workart.id}_short_#{Time.now.to_i}.mp3"
  #     short_public_path = Rails.root.join('public', 'audios', short_filename)
  #     FileUtils.mkdir_p(File.dirname(short_public_path))
  #     FileUtils.cp(short_source_path, short_public_path)
  #     audio_paths[:short] = "/audios/#{short_filename}"
  #     puts "Audio court généré: #{short_public_path}"
  #   end
  # end

  # if @workart.description_middle.present?
  #   middle_source_path = TextToSpeechGeneratorService.call(@workart.description_middle)
  #   if middle_source_path.present?
  #     middle_filename = "workart_#{@workart.id}_middle_#{Time.now.to_i}.mp3"
  #     middle_public_path = Rails.root.join('public', 'audios', middle_filename)
  #     FileUtils.mkdir_p(File.dirname(middle_public_path))
  #     FileUtils.cp(middle_source_path, middle_public_path)
  #     audio_paths[:middle] = "/audios/#{middle_filename}"
  #     puts "Audio middle généré: #{middle_public_path}"
  #   end
  # end

  # if @workart.description_long.present?
  #   long_source_path = TextToSpeechGeneratorService.call(@workart.description_long)
  #   if long_source_path.present?
  #     long_filename = "workart_#{@workart.id}_long_#{Time.now.to_i}.mp3"
  #     long_public_path = Rails.root.join('public', 'audios', long_filename)
  #     FileUtils.mkdir_p(File.dirname(long_public_path))
  #     FileUtils.cp(long_source_path, long_public_path)
  #     audio_paths[:long] = "/audios/#{long_filename}"
  #     puts "Audio long généré: #{long_public_path}"
  #   end
  # end

  # puts "Chemins audio générés: #{audio_paths.inspect}"

  # @audio_paths = audio_paths
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





  private

    def set_workart
      @workart = Workart.find(params[:id])
    end

    def set_user_workart
      @user_workart = UserWorkart.find_by(user: current_user, workart: @workart, liked: true)
    end
end
