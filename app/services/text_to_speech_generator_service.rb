class TextToSpeechGeneratorService
  class << self
    def call(*args, **kwargs, &block)
      new(*args, **kwargs, &block).call
    end
  end

  BASE_URL = 'https://api.elevenlabs.io/v1'
  API_KEY = ENV['XI_API_KEY']
  private_constant :API_KEY
  attr_reader :text, :voice_id, :model_id

  def initialize(text, voice_id = 'N2lVS1w4EtoT3dr4eOWO', model_id = 'eleven_multilingual_v2')
    @text = text
    @voice_id = voice_id
    @model_id = model_id
  end

  def get_voices
    request(:get, "#{BASE_URL}/voices").parsed_response
  end

  def get_models
    request(:get, "#{BASE_URL}/models").parsed_response
  end

  def call
    begin
      url = "#{BASE_URL}/text-to-speech/#{voice_id}?output_format=mp3_44100_128"
      body = { text:, model_id: }

      response = request(:post, url, body:, headers: { 'Accept' => 'audio/mpeg' } ).body
      filepath = "tmp/#{Time.now.strftime('%Y%m%d%H%M%S')}.mp3"
      File.open(filepath, 'wb') do |file|
        file.write(response)
      end
      filepath
    rescue => e
      Rails.logger.error("Error generating audio: #{e.message}")
      raise e
    end
  end

  private

  def request(method, url, body: nil, headers: {})
    default_headers = { 'xi-api-key' => API_KEY, 'Content-Type' => 'application/json' }

    headers = default_headers.merge(headers)

    options = { headers: }

    if method == :post && body.present?
      options[:body] = body.to_json
    end

    response = HTTParty.send(method, url, options)

    if response.success?
      return response
    else
      Rails.logger.error("API error: #{response.body}")
      raise StandardError, "API request failed with status #{response.code}: #{response.body}"
    end
  end
end
