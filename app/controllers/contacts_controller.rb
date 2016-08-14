class ContactsController < ApplicationController

  before_action :ensure_logged_in

  #All contacts page
  def index
    #return json of all contacts if ajax
    if request.xhr?
        @contacts = Contact.all.where(user_id:current_user.id)
        @contacts_render = []
        @contacts.each do |contact|
          person = contact.as_json
          person['show'] = true
          @contacts_render << person
        end
        render json: @contacts_render
    else
      not_found
    end
  end

  #Show one user's info on click
  def show
    @contact = Contact.find(params[:id])
    respond_to do |format|
      #responds to ajax request and executes script on click
      format.js {}
    end
  end

  #Creating a new contact
  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id

    if @contact.save
      respond_to do |format|
        format.js{}
      end
    else
      head :internal_server_errror
    end

  end

  #Delete a contact
  def destroy
    @contact = Contact.find(params[:id])
    if @contact.user_id == current_user.id && @contact.destroy
      redirect_to user_path(current_user)
    else
      head :unauthorized
    end
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.user_id == current_user.id && @contact.update_attributes(contact_params)
      respond_to do |format|
        format.js{}
      end
    else
      head :unauthorized
    end
  end

  #Path is reached when the user is clicked on contacts index
  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js {}  # to show the contacts info in form on all contacts page
    end
  end


  private
  def contact_params
    params.require(:contact).permit(:name, :phone, :email, :category, :twitter_username)
  end
end
