class ContactsController < ApplicationController

  def view
    #write the loop to grab all the messages of all the contacts
  end

  def index
    @contacts = Contact.all
  end

  def show
    @contact = Contact.find(params[:id])
    @messages = @contact.messages

    # if current_Contact
    #   @review = @contact.reviews.build
    # end
  end

  def new
    @contact = Contact.new
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_to contacts_url
    else
      render :new
    end
  end

  def update
    @contact = Contact.find(params[:id])

    if @contact.update_attributes(contact_params)
      redirect_to contact_url(@contact)
    else
      render :edit
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_url
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :phone, :email)
  end
end
