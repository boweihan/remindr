class UsersController < ApplicationController

  before_action :ensure_logged_in, except: [:new, :create]


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    @contacts = @user.contacts
    @contact = Contact.new
  end

  def show
    @user = User.find(params[:id])
    if params[:search]
      @contacts = Contact.search(params[:search])
    else
      @contacts = @user.contacts
    end
    @contact = Contact.new
    if request.xhr?
    @contact = Contact.find(params[:id])
    respond_to do |format|
      #responds to ajax request and executes script on click
      format.js {}
    end
    end
  end

  def create
    @user = User.new(user_params)
    @user.google_id = params[:email]
    if @user.save
      #log the user in
      session[:user_id] = @user.id
      redirect_to googleauth_path
    else
      redirect_to root_path, flash: {signup_modal: true}
    end
  end

  def update
    @user = User.find(params[:id])

     if @user.update_attributes(user_params)
       redirect_to user_path(current_user)
     else
       render :edit
     end

    # respond_to do |format|
    #   if @user.update_attributes(user_params)
    #     format.js {head(:ok)}
    #   else
    #     head(:internal_server_error)
    #   end
    #end

  end

  private
  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation, :reminder_platform)
  end
end
