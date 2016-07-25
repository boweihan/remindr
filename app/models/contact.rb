class Contact < ActiveRecord::Base

  # validates :name, :phone, :email, presence: true

  has_many :messages
  has_many :reminders
  belongs_to :user

  #handle search
  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end

  # gives contacts in that category
  def self.give_contacts_for(category)
    where('category LIKE?', category)
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
    self.user.check_token
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
    free_fields = []
    column_names= Contact.column_names
    column_names.each do |column|
      unless (self.public_send(column) || column == 'id' || column == 'created_at' || column == 'updated_at' ||column =="user_id" )
        free_fields << [column,column]
      end
    end
    return free_fields
  end

  def self.generate_reminder
    @contacts = Contact.all
    @contacts.each do |contact|
      contact.make_reminder
    end
  end

  def make_reminder
    if self.messages != []
      time_difference = (DateTime.now.strftime('%s').to_i) - (self.messages.first.time_stamp)
      message_type = ( ((time_difference/86400) < 30) ? 'upcoming' : 'overdue')
      if self.reminders == []
        Reminder.create(contact_id:self.id, reminder_type:message_type, message:self.messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:self.user_id)
      else
        self.reminders.first.update(contact_id:self.id, reminder_type:message_type, message:self.messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:self.user_id)
      end
    end
  end

  def self.check_sentiment(text)
      alchemyapi = AlchemyAPI.new()
      response = alchemyapi.sentiment("text", text)

      if response['docSentiment']['score'] != nil && response["docSentiment"]["type"] != 'neutral'
        return "Score: " + response['docSentiment']['score'] + " Sentiment: " + response["docSentiment"]["type"]
      end
      "Sentiment: " + response["docSentiment"]["type"]
  end

  def self.easytoner(text)
    response = Easytone::ToneGen.tone(ENV["CLIENT_TONE"], ENV["CLIENT_TONE_SECRET"], text)
  end

  def self.check_sentiment_all_messages
    @messages = Message.all
    array = []
    @messages.each do |message|
      if message.body_plain_text != nil
        myText = message.body_plain_text
        array << check_sentiment(myText)
      end
    end
    array
  end


end
