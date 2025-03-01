class User < ApplicationRecord
  has_many :user_workarts, dependent: :destroy
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :pseudo, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
end
