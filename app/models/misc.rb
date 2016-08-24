#Class for misc. functions
class Misc < ActiveRecord::Base

  def self.automated_email(user, contact)
    subject = "You've been a pretty bad friend..."
    body = "Hey #{user.name},\n Looks like you haven't talked to #{contact.name} for almost a month. You should contact them soon or we'll be reaching out for you! \n \nThe Remind Team"
    send_mail(company_user, user.email, subject, body)
  end
  #create a new client for authentication
  def self.load_google_client
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.parse(ENV['GOOGLE_CLIENT_SECRETS']))
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/userinfo.email ' +
      'https://www.googleapis.com/auth/userinfo.profile '+
      'https://www.googleapis.com/auth/gmail.readonly '+
      'https://www.googleapis.com/auth/gmail.send '+
      'https://www.googleapis.com/auth/contacts.readonly',
      :redirect_uri => 'http://localhost:3000/callback'
        # :redirect_uri => 'http://remindr-me.herokuapp.com/callback'
      )
      @auth_client
  end

  #Send email to a given email
  def self.send_mail(user, to_email, subj, bod)
    email = Mail.new do
      from user.google_id
      to to_email
      subject subj
      body bod
    end


    # create gmail message object and pass in raw body as string
    message = Google::Apis::GmailV1::Message.new
    message.raw = email.to_s

    # start an instance of gmailservice
    service = Google::Apis::GmailV1::GmailService.new

    # check token expiry and refresh if needed
    user.check_token

    service.request_options.authorization = user.access_token
    service.send_user_message(user.google_id, message_object = message)
  end

  def self.send_automated_dm(user, contact)
    subject = "You've been a pretty bad friend..."
    body = "Hey #{user.name}, \nLooks like you haven't talked to #{contact.name} for almost a month. You should contact them soon or we'll be reaching out for you! \n \nThe Remindr Team"
    send_dm(master_account, user.twitter_username,subject, body)
  end

  def self.send_dm(user, recipient, message)
    user.twitter_client.create_direct_message(recipient, message)
  end

  def self.automated_text(user,contact)
    @client = Twilio::REST::Client.new account_sid, auth_token
    number = user.phone[0] == 1 ? "+#{user.phone}" : "+1#{user.phone}"
    @client.account.messages.create({
      :from => '+16474928309',
      :to => phone,
      :body => "Hey #{user.name}, \nLooks like you haven't talked to #{contact.name} for almost a month. You should contact them soon or we'll be reaching out for you! \n \nThe Remindr Team"
    })
  end
end
