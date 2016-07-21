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

      User.where(id:current_user.id).first.update(access_token:token)
      User.where(id:current_user.id).first.update(refresh_token:refresh_token)
      User.where(id:current_user.id).first.update(google_id:id)


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
          # puts email_body
          #store the snippet to be used in the feed
          # puts email_hash['snippet']

          if Message.where(contact_id: contact.id) != []
            Message.where(contact_id: contact.id).first.update(body: email_body)
          else
            Message.create(contact_id: contact.id, user_id: current_user.id, body: email_body)
          end
        else
          puts "that user doesn't exist and therefore doesn't have friends"
        end
      end
    end

    redirect_to '/newsfeed'
  end

  def newsfeed
    #write the loop to grab all the messages of all the contacts with current user
    # puts current_user.id
    # puts Contact.all
    # puts Message.all

    @messages = Array.new
    @contacts = Array.new
    current_user.messages.each do |message|
      @contacts << Contact.find(message.contact_id)
      @messages << message
    end


    #give the newsfeed the ability to send gmail messages (WITH MY CODE GRAVEYARD)
    # gmail_send_url = "https://www.googleapis.com/upload/gmail/v1/users/#{current_user.email}/messages/send?uploadType=media&access_token=#{current_user.access_token}"

    # obj = RestClient::Request.execute(method: :post,
    #                       url: gmail_send_url,
    #                       payload: "{'access_token' : '#{current_user.access_token}' }",
    #                       headers: {uploadType: 'media', Host: 'www.googleapis.com', 'Content-Type': 'message/rfc822', 'Content-Length':0, Authorization: current_user.access_token},
    #                       )
    # user_input = 'From: bowei.han100@gmail.com\r\n
    #               To: CarolYaoo@gmail.com\r\n
    #               Subject: Hello\r\n
    #               Content-Type: text/plain\r\n
    #
    #               Hello, this is a test'
    user_input = Mail.new do
      from 'Bowei Han <bowei.han100@gmail.com>'
      to 'Carol Yao <carolyaoo@gmail.com>'
      subject 'this is a test'
      body 'hello, hello, is it possible? Could this actually work?'
    end
    # enc = Base64.encode64(user_input)
    # enc = enc.gsub("+", "-").gsub("/","_")
    message = Google::Apis::GmailV1::Message.new
    message.raw = user_input.to_s
    service = Google::Apis::GmailV1::GmailService.new
    service.request_options.authorization = current_user.access_token
    obj = service.send_user_message(current_user.google_id, message_object = message)

    #troubleshoot
    email_api_url = "https://www.googleapis.com/gmail/v1/users/#{current_user.google_id}/messages/#{obj.id}?access_token=#{current_user.access_token}"
    puts email_api_url
        binding.pry

  end

  def landing
  end

end
