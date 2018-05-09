class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?, :require_login, :require_logout
  
  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def login_user!
    @user = User.find_by_credentials(session_params[:username], session_params[:password])
    if @user
      session[:session_token] = @user.reset_session_token!
      redirect_to cats_url
    else
      flash[:errors] = ["Invalid username and/or password"]
      redirect_to new_session_url
    end
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    redirect_to new_user_url unless logged_in?
  end
  
  def require_logout
    redirect_to cats_url if logged_in?
  end
  
end
