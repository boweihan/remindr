class PagesController < ApplicationController
  before_action :load_client

  def login_page
  end

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
      #find google email adress of user
      current_user.get_email(current_user.access_token)
      UserLoadFeedJob.perform_later(current_user)
    end
    redirect_to '/login_page'
  end

  def newsfeed
    @contact = Contact.new
    @contacts = current_user.contacts
  end


  def landing
  end

end
