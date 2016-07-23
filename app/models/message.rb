class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user


  #rename bug
  def self.send_mail(sender, receiver, subj, bod, current_user)
    user_input = Mail.new do
      from sender
      to receiver
      subject subj
      body bod
    end
    # enc = Base64.encode64(user_input)
    # enc = enc.gsub("+", "-").gsub("/","_")

    # create gmail message object and pass in raw body as string
    message = Google::Apis::GmailV1::Message.new
    message.raw = user_input.to_s

    # start an instance of gmailservice
    service = Google::Apis::GmailV1::GmailService.new

    # check token expiry and refresh if needed
    if token_expired?(current_user)
      refresh_token(current_user)
      current_user.issued_at = DateTime.now
    end
    
    service.request_options.authorization = current_user.access_token
    service.send_user_message(current_user.google_id, message_object = message)
  end

  def summary
    message = self.body_plain_text
    return message.slice(0,250)+"...."
  end

  def self.refresh_token(current_user)
    response = RestClient.post 'https://accounts.google.com/o/oauth2/token', :grant_type => 'refresh_token', :refresh_token => current_user.refresh_token, :client_id => ENV['CLIENT'], :client_secret => ENV['CLIENT_SECRET']

    refresh = JSON.parse(response.body)
    current_user.access_token = refresh['access_token']
    puts "NEW TOKEN SAVED"
  end

  # check if the token is expired
  def self.token_expired?(current_user)
    issued_at_time = current_user.issued_at.strftime('%s')
    issued_at_time = issued_at_time.to_i+3600
    expiry = DateTime.strptime(issued_at_time.to_s, '%s')
    if expiry < DateTime.now
      puts "THE TOKEN EXPIRED"
      return true
    end
    puts "THE TOKEN IS STILL GOOD"
    return false
  end


end
