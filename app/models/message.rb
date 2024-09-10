class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  after_create_commit -> { broadcast_append_to "chat_#{chat_id}_messages", partial: 'messages/message', locals: { message: self, current_user: user } }

  def sender?(a_user)
    user.id == a_user.id
  end

  private

  def broadcast_message
    broadcast_append_to "chat_#{chat.id}_messages",
                        partial: "messages/message",
                        locals: { message:self, current_user: user }
  end
end
