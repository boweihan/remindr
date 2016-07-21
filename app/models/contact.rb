class Contact < ActiveRecord::Base
  has_many :messages
  belongs_to :user

  #handle photos
  def self.update
    all_contacts = Contact.all
    all_contacts.each do |contact|
      contact.get_most_recent_message
      puts "in update loop"
    end
  end

  def get_most_recent_message
    if self.email
      self.get_email
    else
      puts "Contact has no email"
    end
  end

  def get_email
    token = self.user.access_token
    user_google_id = self.user.google_id
    email_id = self.search_email(user_google_id, token)
    if email_id
      email = self.fetch_email(user_google_id, token, email_id)
      status = first_interaction?(self)
      if status && email
        Message.create(contact_id: self.id, user_id: self.user.id, body: email['body'], time_stamp:email['time_stamp'])
      elsif email
        Message.where(contact_id: self.id).first.update(body: email['body'], time_stamp:email['time_stamp'])
      end
    else
      puts "error can't find emails with that user"
    end
  end

  def search_email(user_google_id, token)
    #change to to
    q= "from:#{self.email}"
    query_email_api_url = "https://www.googleapis.com/gmail/v1/users/#{user_google_id}/messages?maxResults=1&q=#{q}&access_token=#{token}"
    if JSON.parse(RestClient.get(query_email_api_url))['messages']
      email_id = JSON.parse(RestClient.get(query_email_api_url))['messages'][0]['id']
      return email_id
    else
      return nil
    end
  end

  def fetch_email(user_google_id, token, email_id)
    api_url = "https://www.googleapis.com/gmail/v1/users/#{user_google_id}/messages/#{email_id}?access_token=#{token}"
    puts api_url
    email = JSON.parse(RestClient.get(api_url))
    message = {}
    message['time_stamp'] = email['internalDate'].slice(0,10).to_i
    #decode mime base64
    if email['payload']['parts'][1]['body']['data'].class == String
      message['body'] = email['payload']['parts'][1]['body']['data']
      message['body'] = Base64.decode64(message['body'].gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s
      return message
    else
      puts "image"
      message['body'] = "IMAGE*****"
      return message
    end
  end

  def first_interaction?(contact)
    if Message.where(contact_id: contact.id) != []
      return false
    else
      return true
    end
  end

  def neglected?
    message = self.messages.first
    unless message == true
      #hack pelase fix
      Message.create(time_stamp:Time.now.to_i - 100000, contact_id: self.id, user_id: self.user.id)
      return false
    end
    # binding.pry
    days_since = ((message.time_stamp - Time.now.to_i)/86400.0).floor
    if days_since == 30
      return true
    end
  end
end
