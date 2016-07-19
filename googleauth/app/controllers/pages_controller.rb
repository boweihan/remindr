class PagesController < ApplicationController
  before_action :load_client

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

  def index
      auth_uri = @auth_client.authorization_uri.to_s
      redirect_to auth_uri
  end

  def callback
    if params[:error]
      puts "error"

    elsif params[:code]
      #client accepted scopes. use authorization code in qs
      @auth_client.code = params[:code]

      #exchange auth for token
      @auth_client.fetch_access_token!
      token = @auth_client.access_token

      #get id
      url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{token}"
      obj = RestClient.get(url)
      id = JSON.parse(obj)['id']

      q= "from:contact@codecademy.com"
      #get messages list
      api_url = "https://www.googleapis.com/gmail/v1/users/#{id}/messages?maxResults=1&q=#{q}&access_token=#{token}"
      puts api_url
      email_id = JSON.parse(RestClient.get(api_url))['messages'][0]['id']

      #get 1 mesage
      email_api_url = "https://www.googleapis.com/gmail/v1/users/#{id}/messages/#{email_id}?access_token=#{token}"
      puts email_api_url
      email_obj = RestClient.get(email_api_url)
      email_hash = JSON.parse(email_obj)

      # 0 text, 1 html
      email_body = email_hash['payload']['parts'][0]['body']['data']
      #decode
      email_body = Base64.decode64(email_body.gsub("-", '+').gsub("_","/"))
    end

    redirect_to '/garbage'
  end

  def garbage
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
