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


  def edit
    @contact = Contact.find(params[:id])
    respond_to  do |format|
      format.html {}
      format.json {render json: @contact}
      format.js {}  # to show the contacts info in form on all contacts page
    end

  end

  def show
    @contact = Contact.find(params[:id])
    @messages = @contact.messages

    respond_to do |format|
      format.html
      format.js {}
    end
    # if current_Contact
    #   @review = @contact.reviews.build
    # end
  end


  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    if @contact.save
      redirect_to contacts_url
    else
      render :new
    end
  end

  def update
    if request.xhr?
      @contact = Contact.find(params[:id])
      @attribute = params[:attribute]
      @contact.update(@attribute.to_sym =>params[:new])
      render :nothing => true, :status => 200, :content_type => 'text/html'
    else
      @contact = Contact.find(params[:id])

      if @contact.update_attributes(contact_params)
        redirect_to contact_url(@contact)
      else
        render :edit
      end
    end


  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_url
  end

  def update_contact_patch
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(contact_params)
        format.html {}
        format.js   {}
      else
        redirect_to contacts_path
      end
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

  def friends
    if request.xhr?
      @contacts = Contact.all.where(user_id:current_user.id)
      @friends = Misc.give_contacts_for(@contacts, 'friend')
        render json: {objects: @friends }
    else
      not_found
    end
  end

  def business
    if request.xhr?
      @contacts = Contact.all.where(user_id:current_user.id)
      @business = Misc.give_contacts_for(@contacts, 'business')
      render json: {objects: @business }
    else
      not_found
    end
  end


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
    params.require(:contact).permit(:name, :phone, :email, :category)
  end
end
