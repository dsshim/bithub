class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_auth(oauth_data)
    if user
      session[:user_id] = user.id
      flash[:success] = "Welcome Back #{current_user.nickname}!"
      redirect_to dashboard_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out!"
    redirect_to root_path
  end

  private
  def oauth_data
    request.env["omniauth.auth"]
  end
end
