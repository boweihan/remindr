class UsersController < ApplicationController

  before_action :ensure_logged_in, except: [:new, :create]


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.google_id = params[:email]
    if @user.save
      #log the user in
      session[:user_id] = @user.id
      redirect_to googleauth_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to user_url(@user)
    else
      render :edit
    end
  end



  private
  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
