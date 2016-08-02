class Contact < ActiveRecord::Base
  #Contact must have name
  validates :name, presence: true

  #Activerecord associations
  has_many :messages
  has_many :reminders
  belongs_to :user


  #Load a contact's direct messages from twitter
  def get_dms(user_client, current_user)
    dms = []
    # loop through messages and store them in dms array
    user_client.direct_messages_sent(options = {}).each do |direct_message|
      if direct_message.recipient.screen_name == self.twitter_username
        message = {}
        message['time_stamp'] = direct_message.created_at
        message['text'] = direct_message.text
        message['html'] = nil
        dms << message
      end
    end
    # last_message = dms.first
    if dms.length > 0
      return dms
    else
      return []
    end
      # dm_exist = message_exist?(self, last_message.created_at)
      # if !dm_exist
        # Message.create(contact_id: self.id, user_id: current_user.id, body_plain_text: last_message.text, time_stamp: last_message.created_at)
      # end
  end

  #Query for contacts that match the category
  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end

  # gives contacts in that category
  def self.give_contacts_for(category)
    where('category LIKE?', category)
  end

  #handle photos******

  #Called during scheduled task to get the most recent interaction with every contact
  def self.update
    all_contacts = Contact.all
    all_contacts.each do |contact|
      contact.get_most_recent_message
    end
  end

  #Get most recent email
  def get_most_recent_message
    message_list = []
    #Check if email exists for contact
    if email
      #Fetch email
      message_list += get_email
    end

    if user.token
      message_list += get_dms(user.twitter_client,user)
    end
    if message_list.length > 0
      db_messages = messages
      converted = []
      message_list.each do |message|
        a = message
        a['time_stamp']= a['time_stamp'].to_i
        converted << a
      end
      sorted = converted.sort_by{|message| message['time_stamp']}.reverse

      Message.destroy_all(contact_id: id)
      i=0
      while i<=4 && i < sorted.length
        Message.create(user_id: user.id, contact_id: id, time_stamp: sorted[i]['time_stamp'], body_plain_text: sorted[i]['text'], body_html: sorted[i]['html'], snippet: sorted[i]['snippet'])
        i+= 1
      end

    else
      if messages.all.length == 0
      # Create a message with no body to start countdown of 30 days if there is no email for contact
      Message.create(time_stamp:Time.now.to_i, contact_id: id, user_id: user.id, body_plain_text: "~", snippet: 'No available messages')
      end
    end
    #   #Create a message with no body to start countdown of 30 days if there is no email for contact
    #     Message.create(time_stamp:Time.now.to_i, contact_id: id, user_id: user.id)
    #   end
  end

  #Make api calls to gmail
  def get_email
    #Get new token for the user associated with contact if expired
    user.check_token
    token = user.access_token
    user_google_id = user.google_id
    #Query gmail to find email_id of last email
    email_ids = search_email(user_google_id, token)
    #Past interactions exist
    if email_ids
      emails = []
      #Find email body an message details
      email_ids.each do |id|
        emails << fetch_email(user_google_id, token, id)
      end
      return emails
      #Since only 1 message is being saved, we have to check if its the first interaction
      #Between contact and user to decide if we should overwrite an existing entry for message
      #Or Make a new one
    #   status = first_interaction?(self)
    #   exist = message_exist?(self, email['time_stamp'])
    #   if email && !exist
    #     Message.create(contact_id: id, user_id: user.id, body_plain_text: email['text'], body_html: email['html'], time_stamp:email['time_stamp'])
    #   end
    # #No past email interactions
    # else
    #   unless messages.first
    #     #Create a message with no body to start countdown of 30 days if no email has been sent to the contact.
    #     #This happens when the user is newly created.
    #     Message.create(time_stamp:Time.now.to_i, contact_id: id, user_id: user.id)
    #   end
    else
      return []
    end
  end

  #Finds email id of most recent outbound email from user to contact
  def search_email(user_google_id, token)
    #search string
    query= "from:#{email}"
    query_email_api_url = "https://www.googleapis.com/gmail/v1/users/#{user_google_id}/messages?maxResults=5&q=#{query}&access_token=#{token}"
    #True if there are past interactions on email
    if JSON.parse(RestClient.get(query_email_api_url))['messages']
      email_ids = []
      JSON.parse(RestClient.get(query_email_api_url))['messages'].each do |message|
        email_ids << message['id']
      end
      return email_ids
    else
      return nil
    end
  end

  #Gets email body given the email_id
  def fetch_email(user_google_id, token, email_id)
    api_url = "https://www.googleapis.com/gmail/v1/users/#{user_google_id}/messages/#{email_id}?access_token=#{token}"
    email = JSON.parse(RestClient.get(api_url))
    message = {}
    #Slice for unixtime in seconds because it is given in ms
    message['time_stamp'] = email['internalDate'].slice(0,10).to_i
    #parts[0] gives plaintext and parts[1] gives html
    #check if email body is string (could be image)
    message['snippet'] = email['snippet']
    if email['payload']['body']['data'] != nil
      text = email['payload']['body']['data']
      message['text'] = Base64.decode64(text.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s
      return message
      message['snippet'] = email['snippet']
    elsif email['payload']['parts'][0]['body']['data'].class == String

      plain = email['payload']['parts'][0]['body']['data']
      #Convert mimebase64 into utf8
      message['text'] = Base64.decode64(plain.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s

      html = email['payload']['parts'][1]['body']['data']
      if html != nil
        message['html'] = Base64.decode64(html.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s
      end
      #both copies *html and text are returned and saved in db
      return message
    else
      #handles non-text interactions
      puts "image"
      message['html'] = "IMAGE*****"
      message['text'] = "IMAGE*****"
      return message
    end
  end

  #check if contact and user have interacted before
  def first_interaction?(contact)
    if Message.where(contact_id: contact.id) != []
      return false
    else
      return true
    end
  end

  def message_exist?(contact, timestamp)
    if Message.where(time_stamp: timestamp) != []
      return true
    else
      return false
    end
  end

  #check if you havent talked to your contact for 30 days
  # method called daily
  def neglected?
    message = messages.first
    #days since last interaction
    days_since = ((message.time_stamp - Time.now.to_i)/86400.0).floor
    if days_since == 30
      return true
    else
      return false
    end
  end

  #capitalizes db columns and makes it easy to print out and only prints filled columns
  def pretty_print
    column_names= Contact.column_names
    valid_fields = []
    column_names.each do |column|
      #Checks filled columns and prints them if they should be visible to user
      if (self.public_send(column) && column != 'name' && column != 'id' && column != 'created_at' && column != 'updated_at' && column != "user_id")
        valid_fields << "#{column.capitalize}: #{self.public_send(column)}"
      end
    end
    valid_fields
  end

  #Find empty fields in db that can be edited to create dynamic dropdown
  def generate_selectors
    editable = []
    column_names= Contact.column_names
    column_names.each do |column|
      #dynamically calls method given by string stored in variable column (ex name, id..)
      unless self.public_send(column)
        editable << [column,column]
      end
    end
    editable
  end

  #Called daily to update the reminders seen on dashboard
  def self.update_reminders
    all.each do |contact|
      if contact.messages != []
        contact.update_reminder
      end
    end
  end

  #update reminder for each contact
  def update_reminder
    #Time since last contact
    time_difference = (DateTime.now.strftime('%s').to_i) - (messages.first.time_stamp)
    #Status of interactions
    message_type = ( ((time_difference/86400) < 30) ? 'upcoming' : 'overdue')
    #Check if you should update an existing reminder or create a new one
    if reminders == []
      Reminder.create(contact_id:id, reminder_type:message_type, message:messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:user_id)
    else
      reminders.first.update(contact_id:id, reminder_type:message_type, message:messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:user_id)
    end
  end

end
