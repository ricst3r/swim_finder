class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :chat_users
  has_many :users, through: :chat_users

def self.between(user1, user2)
 user1_chats = user1.chats
 user2_chats = user2.chats

 (user1_chats & user2_chats).first
end


end
