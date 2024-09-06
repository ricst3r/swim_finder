class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users

  scope :between, -> (sender_id, recipient_id) do
    where("(chats.user_ids @> ARRAY[?]::integer[] AND chats.user_ids @> ARRAY[?]::integer[])", sender_id, recipient_id)
  end

  def self.between(user1_id, user2_id)
    where("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
          user1_id, user2_id, user2_id, user1_id)
  end
end
