class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages.order(created_at: :asc)
    @message = Message.new
  end

  def create
    recipient = User.find(params[:recipient_id])
    @chat = Chat.between(current_user.id, recipient.id).first_or_create!(user_ids: [current_user.id, recipient.id])
    redirect_to @chat
  end
end
 