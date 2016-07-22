class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user

  #rename bug
  def self.send_mail(sender, receiver, subj, bod, current_user)
    user_input = Mail.new do
      # from 'Bowei Han <bowei.han100@gmail.com>'
      # to 'Carol Yao <carolyaoo@gmail.com>'
      # subject 'this is a test'
      # body 'hello, hello, is it possible? Could this actually work?'
      from sender
      to receiver
      subject subj
      body bod
    end
    # enc = Base64.encode64(user_input)
    # enc = enc.gsub("+", "-").gsub("/","_")
    message = Google::Apis::GmailV1::Message.new
    message.raw = user_input.to_s
    service = Google::Apis::GmailV1::GmailService.new
    # need to add refresh token here
    service.request_options.authorization = current_user.access_token
    service.send_user_message(current_user.google_id, message_object = message)
  end

  def summary
    message = self.body_plain_text
    return message.slice(0,250)+"...."
  end
end
