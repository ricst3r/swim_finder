class UsersController < ApplicationController

  def show
    @user = User.find_by(username: params[:username])
    @user = User.find(params[:username]) if @user.nil?
    @locations = @user.locations
  end


end
