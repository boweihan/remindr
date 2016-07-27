#Class for misc. functions
class Misc < ActiveRecord::Base

  #Send email to a given email
  def self.send_mail(user, to_email, subj, bod)
    user_input = Mail.new do
      from user.google_id
      to to_email
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

end
