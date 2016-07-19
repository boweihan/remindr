class PagesController < ApplicationController
  before_action :load_client

  def load_client
    client_secrets = Google::APIClient::ClientSecrets.load
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/gmail.readonly '+
                'https://www.googleapis.com/auth/gmail.send',
      :redirect_uri => 'http://localhost:3000/callback'
      )
  end

  def index
      auth_uri = @auth_client.authorization_uri.to_s
      redirect_to auth_uri
  end

  def callback
    if params[:error]
      puts "error"

    elsif params[:code]
      @auth_client.code = params[:code]
      @auth_client.fetch_access_token!
      # Initialize the API
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = @auth_client
      # Show the user's labels
      user_id = 'me'
      result = service.list_user_messages(
       user_id,
       max_results: 1,
       q: 'from:contact@codecademy.com',
      )
      result = result.messages
      result.each do |text|
       text_body = service.get_user_message(
         user_id,
         text.id,
       )
       puts (text_body.payload.parts)[1].body.data
      end
      puts "success"
      puts @auth_client.inspect
    end

    redirect_to '/garbage'
  end

  def garbage
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
