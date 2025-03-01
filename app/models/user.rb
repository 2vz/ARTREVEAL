class User < ApplicationRecord
  has_many :user_workarts, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :pseudo, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
end
