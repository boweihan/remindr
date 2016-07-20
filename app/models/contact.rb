class Contact < ActiveRecord::Base
  has_many :messages
  belongs_to :user

  def self.update
    all_contacts = Contact.all
    all_contacts.each do |contact|
      contact.get_most_recent_message
    end
  end

  def get_most_recent_messages
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
    email = self.fetch_email(user_google_id, token, email_id)
    if first_interaction?
      Message.create(contact_id: self.id, user_id: self.user.id, body: email)
    else
      Message.where(contact_id: self.id).first.update(body: email)
    end
  end

  def search_email(user_google_id, token)
    q= "to:#{self.email}"
    query_email_api_url = "https://www.googleapis.com/gmail/v1/users/#{user_google_id}/messages?maxResults=1&q=#{q}&access_token=#{token}"
    if JSON.parse(RestClient.get(api_url))['messages']
      email_id = JSON.parse(RestClient.get(api_url))['messages'][0]['id']
      return email_id
    else
      puts "Error"
    end
  end

  def fetch_email(user_google_id, token, email_id)
    api_url = "https://www.googleapis.com/gmail/v1/users/#{user_google_id}/messages/#{email_id}?access_token=#{token}"
    email = JSON.parse(RestClient.get(email_api_url))
    #0 plain text, 1 html
    email_body = email_hash['payload']['parts'][1]['body']['data']
    #decode mime base64
    email_readable_body = Base64.decode64(email_boy.gsub("-", '+').gsub("_","/")))
    email_in_html = email_readable_body.force_encoding("utf-8").to_s
  end

  def first_interaction?
    if Message.where(contact_id: contact.id)
      return false
    else
      return true
    end
  end
end
