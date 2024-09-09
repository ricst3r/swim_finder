class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages.order(created_at: :asc)
    @message = Message.new
    @user = @chat.their_user(current_user)
  end

  def create
    recipient = User.find(params[:user_id])
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

  def index
    @chats = current_user.chats.order(created_at: :desc)
  end


end
