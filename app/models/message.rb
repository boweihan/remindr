class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user


  #rename bug
  def self.send_mail(sender, receiver, subj, bod, user)
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
    user.check_token

    service.request_options.authorization = user.access_token
    service.send_user_message(user.google_id, message_object = message)
  end

  def summary
    message = self.body_plain_text
    return message.slice(0,250)+"...."
  end

end
