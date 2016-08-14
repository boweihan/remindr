class SessionsController < ApplicationController


  #on login
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # redirect_to '/googleauth', notice: "Thanks for logging in!"
      redirect_to '/newsfeed'
    else
      @user = User.new
      redirect_to root_path, flash: {login_modal: true}
    end
  end

  #on logout
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have logged out."
  end


end
