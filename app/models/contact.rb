class Contact < ActiveRecord::Base

  validates :name, :phone, :email, presence: true

  has_many :messages
  has_many :reminders
  belongs_to :user

  #handle search
  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end
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
        Message.create(contact_id: self.id, user_id: self.user.id, body_plain_text: email['text'], body_html: email['html'], time_stamp:email['time_stamp'])
      elsif email
        Message.where(contact_id: self.id).first.update(body_plain_text: email['text'], body_html: email['html'], time_stamp:email['time_stamp'])
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
    #0 text, 1 html
    if email['payload']['parts'][1]['body']['data'].class == String
      plain = email['payload']['parts'][0]['body']['data']
      message['text'] = Base64.decode64(plain.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s

      html = email['payload']['parts'][1]['body']['data']
      message['html'] = Base64.decode64(html.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s

      return message
    else
      puts "image"
      message['html'] = "IMAGE*****"
      message['text'] = "IMAGE*****"
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

  def pretty_print
    column_names= Contact.column_names
    valid_fields = []
    column_names.each do |column|
      if (self.public_send(column) && column != 'name' && column != 'id' && column != 'created_at' && column != 'updated_at' && column != "user_id")
        valid_fields << "#{column.capitalize}: #{self.public_send(column)}"
      end
    end
    return valid_fields
  end

  def generate_selectors
    column_names= Contact.column_names
    free_fields = []
    column_names.each do |column|
      unless (self.public_send(column) || column == 'id' || column == 'created_at' || column == 'updated_at' ||column =="user_id" )
        free_fields << [column,column]
      end
    end
    return free_fields
  end

  def self.generate_reminder(current_user)
    @contacts = Contact.all
    @contacts.each do |contact|
      if contact.messages != []
        time_difference = (DateTime.now.strftime('%s').to_i) - (contact.messages.first.time_stamp)
        message_type = check_message_overdue(time_difference/86400)
        if contact.reminders == []
          Reminder.create(contact_id:contact.id, reminder_type:message_type, message:contact.messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:current_user.id)
        else
          Reminder.update(contact_id:contact.id, reminder_type:message_type, message:contact.messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:current_user.id)
        end
      else
      end

      # convert milliseconds to day and store in reminder database along with message, message type, contact id
      # message_type =
      # Reminder.create(contact_id:contact.id, type:message_type message:message.body_plain_text, time_since_last_contact:time_difference)
    end
  end

  def self.check_message_overdue(days)
    if days < 30
      return 'upcoming'
    else
      return 'overdue'
    end
  end
end
