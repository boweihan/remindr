#Class for misc. functions
class Misc < ActiveRecord::Base

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
    user_input = Mail.new do
      from user.google_id
      to to_email
      subject subj
      body bod
    end


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

  #Query for contacts that match the category
  def self.give_contacts_for(collection, category)
    collection.where(category: category)
  end

  #method for sending twitter DMS when the 30 days are up
  def self.send_twitter_dm(user, text)
    Message.create_direct_message_auto(user, text)
  end
end
