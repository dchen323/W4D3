class UsersController < ApplicationController
  before_action :require_logout, only: [:new]
 
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    @user.password = user_params[:password]
    session[:session_token] = @user.ensure_session_token
    if @user.save
      redirect_to cats_url
    end
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password)
  end
end