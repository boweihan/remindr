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
      token = @auth_client.access_token
      refresh_token = @auth_client.refresh_token

      #get id
      url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{token}"
      puts url
      obj = RestClient.get(url)
      id = JSON.parse(obj)['id']

      current_user.access_token = token
      current_user.refresh_token = refresh_token
      current_user.google_id = id

      Contact.where(user_id: current_user.id).each do |contact|
        q= "from:#{contact.email}+OR+to:#{contact.email}"
        # q= "to:#{contact.email}"
        #get messages list
        api_url = "https://www.googleapis.com/gmail/v1/users/#{id}/messages?maxResults=1&q=#{q}&access_token=#{token}"
        # puts api_url
        if JSON.parse(RestClient.get(api_url))['messages'] && contact.email

          email_id = JSON.parse(RestClient.get(api_url))['messages'][0]['id']

          #get 1 mesage
          email_api_url = "https://www.googleapis.com/gmail/v1/users/#{id}/messages/#{email_id}?access_token=#{token}"
          # puts email_api_url
          email_obj = RestClient.get(email_api_url)
          email_hash = JSON.parse(email_obj)

          # 0 text, 1 html

          # write loop to check if the part is actually plain/text (not an image or other)
          email_body = email_hash['payload']['parts'][1]['body']['data']
          #decode
          email_body = Base64.decode64(email_body.gsub("-", '+').gsub("_","/"))
          email_body = email_body.force_encoding("utf-8").to_s
          puts email_body

          if Message.where(contact_id: contact.id)
            Message.where(contact_id: contact.id).first.update(body: email_body)
          else
            Message.create(contact_id: contact.id, user_id: current_user.id, body: email_body)
          end
          binding.pry
        else
          puts "that user doesn't exist and therefore doesn't have friends"
        end
      end
    end

    redirect_to '/newsfeed'
  end

  def newsfeed
    #write the loop to grab all the messages of all the contacts with current user
    puts current_user.id
    puts Contact.all
    puts Message.all

    @messages = Array.new
    @contacts = Array.new
    current_user.messages.each do |message|
      @contacts << Contact.find(message.contact_id)
      @messages << message
    end

  end

  def landing
  end

end
