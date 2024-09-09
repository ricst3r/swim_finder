class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :image
  has_many :reviews
  has_many :locations
  has_many :favorites
  has_many :messages, dependent: :destroy
  has_many :chat_users, dependent: :destroy
  has_many :chats, through: :chat_users

  validates :username, presence: true, uniqueness: true
end
