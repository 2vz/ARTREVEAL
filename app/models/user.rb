class User < ApplicationRecord
  has_many :user_workarts, dependent: :destroy
  has_many :favorites_workarts, through: :user_workarts, source: :workart
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :pseudo, presence: true, uniqueness: true
  # validates :first_name, :last_name, presence: true
  def likes?(workart)
    user_workarts.exists?(workart: workart, liked: true)
  end
end
