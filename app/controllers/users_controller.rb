class UsersController < ApplicationController

  before_action :ensure_logged_in, except: [:create]


  def index
    @users = User.all
  end



  def edit
    @user = User.find(params[:id])
    @contacts = @user.contacts
    @contact = Contact.new
  end

  def show
    if current_user.id.to_s != params[:id]
      head(:forbidden)
    else
      @user = current_user
      @contacts = @user.contacts
      @contact = Contact.new
      if request.xhr?
        @contact = Contact.find(params[:id])
        respond_to do |format|
          #responds to ajax request and executes script on click
          format.js {}
        end
      end
    end
  end


  def create
    @user = User.new(user_params)
    @user.google_id = params[:email]
    @user.reminder_platform = "Email"
    @user.automated_message = "Hi! It's been a while since we've talked and I miss you dearly. I've been thinking about you recently and want to take our relationship to the next level."
    if @user.save
      #log the user in
      session[:user_id] = @user.id
      redirect_to googleauth_path
    else
      redirect_to root_path, flash: {signup_modal: true}
    end
  end


  def update
    if params[:id] != current_user.id.to_s
      head(:forbidden)
    else
      @user = current_user
      @information = user_params

      unless @user.update_attributes(@information)
        head(:internal_server_error)
      end
    end
  end


  private
  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation, :reminder_platform, :automated_message)
  end
end
