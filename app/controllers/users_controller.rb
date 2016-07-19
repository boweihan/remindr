class UsersController < ApplicationController

  before_action :ensure_logged_in, except: [:new,:create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])

    # if current_user
    #   @review = @user.reviews.build
    # end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      #log the user in
      redirect_to newsfeed_path
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

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
