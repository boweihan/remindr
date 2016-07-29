class ContactsController < ApplicationController

  before_action :ensure_logged_in

  #All contacts page
  def index
    #return json of all contacts if ajax
    if request.xhr?
        @contacts = Contact.all.where(user_id:current_user.id)
        render json: @contacts
    else
      # create a new contact to render form
      @contact = Contact.new
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
      redirect_to newsfeed_path
    else
      render :new
    end
  end

  # path to update one attribute
  def update
    if request.xhr?
      @contact = Contact.find(params[:id])
      @attribute = params[:attribute]
      if @contact.update(@attribute.to_sym =>params[:new])
        head :ok, content_type: "text/html"
      else
        head :internal_server_errror
      end
    end
  end

  #Delete a contact
  def destroy
    @contact = Contact.find(params[:id])
    if @contact.destroy
      redirect_to contacts_url
    else
      head :internal_server_errror
    end

  end

  #update all attributes
  def update_contact_patch
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(contact_params)
        format.js {}
      else
        head :internal_server_errror
      end
    end
  end

  #Path is reached when the user is clicked on contacts index
  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js {}  # to show the contacts info in form on all contacts page
    end
  end


  #All, Friends, Business, Family paths will throw 404 if not accesed by ajax. Called by contact index page
  def all
    #only allow access if the route is called by ajax
    if request.xhr?
      @all = Contact.all.where(user_id:current_user.id)
        #handlebars iterates through all values in the objects key for templating
        render json: {objects: @all }
    else
      not_found
    end
  end

  #Friends tab
  def friends
    if request.xhr?
      @contacts = Contact.all.where(user_id:current_user.id)
      @friends = Misc.give_contacts_for(@contacts, 'friend')
        render json: {objects: @friends }
    else
      not_found
    end
  end

  #Business tab
  def business
    if request.xhr?
      @contacts = Contact.all.where(user_id:current_user.id)
      @business = Misc.give_contacts_for(@contacts, 'business')
      render json: {objects: @business }
    else
      not_found
    end
  end

  #Family tab
  def family
    if request.xhr?
      @contacts = Contact.all.where(user_id:current_user.id)
      @family = @contacts.give_contacts_for('family')
      render json: {objects: @family }
    else
      not_found
    end
  end


  private
  def contact_params
    params.require(:contact).permit(:name, :phone, :email, :category, :twitter_username)
  end
end
