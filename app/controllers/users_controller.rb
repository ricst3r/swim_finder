class UsersController < ApplicationController

  def show
    @user = User.find_by(username: params[:username])
    @locations = @user.locations
  end

end
