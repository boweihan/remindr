class PagesController < ApplicationController
  before_action :load_client

  def dashboard
  end
  def load_client
    client_secrets = Google::APIClient::ClientSecrets.load
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/userinfo.email ' +
      'https://www.googleapis.com/auth/userinfo.profile '+
      'https://www.googleapis.com/auth/gmail.readonly '+
      'https://www.googleapis.com/auth/gmail.send',
      :redirect_uri => 'http://localhost:3000/callback'
      )
  end


  def googleauth
      auth_uri = @auth_client.authorization_uri.to_s
      redirect_to auth_uri
  end

  def callback
    #if user clicks deny
    if params[:error]
      puts "error"

    elsif params[:code]
      #client accepted scopes. use authorization code in qs
      @auth_client.code = params[:code]
      #exchange auth for token
      @auth_client.fetch_access_token!
      current_user.update({access_token: @auth_client.access_token, refresh_token: @auth_client.refresh_token, issued_at: @auth_client.issued_at})
      current_user.get_email(current_user.access_token)
    end
    redirect_to '/newsfeed'
  end

  def newsfeed
    #write the loop to grab all the messages of all the contacts with current user

    # puts current_user.id
    # puts Contact.all
    # puts Message.all
    #
    # @messages = Array.new
    # @contacts = Array.new
    # current_user.messages.each do |message|
    #   @contacts << Contact.find(message.contact_id)
    #   @messages << message
    @contacts = current_user.contacts
    # create new contact on page to be able to add contact on newsfeed for modal
    @contact = Contact.new


  end


  def landing
  end

end
