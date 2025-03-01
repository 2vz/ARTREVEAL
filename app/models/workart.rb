class Workart < ApplicationRecord
  has_many :user_workarts, dependent: :destroy

  validates :description_short, :description_middle, :description_long, :image_url, presence: true
  validates :primary_artist, uniqueness: { scope: :workart_title}

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

end
