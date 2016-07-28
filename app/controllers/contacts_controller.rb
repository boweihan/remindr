class ContactsController < ApplicationController

  before_action :ensure_logged_in

  def index
    # create a new contact to render form
    @contact = Contact.new
    # @messages = []
    # @contacts.each do |contact|
    #   @messages << contact.messages
    # end

    @contacts = Contact.all.where(user_id:current_user.id)
    respond_to do |format|
      format.html {}
      format.json {render json: @contacts}
    end

  end


  def all
    @all = Contact.all.where(user_id:current_user.id)
    respond_to do |format|
      format.html {}
      format.json {render json: {objects: @all }}
    end
  end

  def friends
    @contacts = Contact.all.where(user_id:current_user.id)
    @friends = @contacts.give_contacts_for('friend')
    respond_to do |format|
      format.html {}
      format.json {render json: {objects: @friends }}
    end
  end

  def business
    @contacts = Contact.all.where(user_id:current_user.id)
    @business = @contacts.give_contacts_for('business')
    respond_to do |format|
      format.html {}
      format.json {render json: {objects: @business }}
    end
  end

  def family
    @contacts = Contact.all.where(user_id:current_user.id)
    @family = @contacts.give_contacts_for('family')
    respond_to do |format|
      format.html {}
      format.json {render json: {objects: @family }}
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

  def new
    @contact = Contact.new
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to  do |format|
      format.html {}
      format.json {render json: @contact}
      format.js {}  # to show the contacts info in form on all contacts page
    end

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
    redirect_to contacts_path
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

  private
  def contact_params
    params.require(:contact).permit(:name, :phone, :email, :category)
  end
end
