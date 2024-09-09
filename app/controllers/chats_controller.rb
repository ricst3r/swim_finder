class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages.order(created_at: :asc)
    @message = Message.new
  end

  def create
    recipient = User.find(params[:recipient_id])
    @chat = Chat.between(current_user, recipient)
    if @chat
    redirect_to chat_path(@chat)
    else
      @chat = Chat.create
      ChatUser.create(chat: @chat, user: current_user)
      ChatUser.create(chat: @chat, user: recipient)
      redirect_to chat_path(@chat)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
