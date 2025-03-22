class Workart < ApplicationRecord
  has_many :user_workarts, dependent: :destroy
  has_one_attached :image

  validates :description_short, :description_middle, :description_long, :image_url, presence: true
  validates :primary_artist, uniqueness: { scope: :workart_title}
  has_one_attached :photo

  validates :description_short, :description_middle, :description_long, presence: true
  validates :primary_artist, presence: true
  validates :primary_artist, uniqueness: { scope: :workart_title}

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def call_text_to_speech_service(description_type)
    Rails.cache.fetch("#{cache_key_with_version}/call_text_to_speech_service") do
      TextToSpeechGeneratorService.call(send(description_type))
    end
  end
end
