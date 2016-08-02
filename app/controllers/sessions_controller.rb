class SessionsController < ApplicationController

  #signin form
  def new
    # render :layout => false
  end

  #on login
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # redirect_to '/googleauth', notice: "Thanks for logging in!"
      redirect_to '/login_page'
    else
      @user = User.new
      render "pages/landing"
    end
  end

  #on logout
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have logged out."
  end


end
