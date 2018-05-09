class SessionsController < ApplicationController
  before_action :require_logout, only: [:new]
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    login_user!
    # @user = User.find_by_credentials(session_params[:username], session_params[:password])
    # if @user
    #   session[:session_token] = @user.reset_session_token!
    #   redirect_to cats_url
    # else
    #   flash[:errors] = ["Invalid username and/or password"]
    #   redirect_to new_session_url
    # end
  end
  
  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
    end
    redirect_to new_session_url
  end
  
  private
  
  def session_params
    params.require(:session).permit(:username, :password)
  end
end