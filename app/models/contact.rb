class Contact < ActiveRecord::Base

  validates :name, :user_id, presence: true

  has_many :messages
  has_many :reminders
  belongs_to :user

  #email a user's contacts that have been neglected
  def reach_out
    case user.reach_out_platform
      when "Email"
        Misc.send_mail(user, contact.email, "It's been a while...",user.automated_message)
      when "Twitter"
        Misc.send_dm(self, contact)
    end
  end

  #Load a contact's direct messages from twitter
  def get_dms(user_client)
    dms = []
    # loop through messages and store them in dms array
    user_client.direct_messages_sent(options = {}).each do |direct_message|
      if direct_message.recipient.screen_name == self.twitter_username
        message = {}
        message['time_stamp'] = direct_message.created_at.to_i
        message['text'] = direct_message.text
        dms << message
      end
    end
    dms
  end


  #Called during scheduled task to get the most recent interaction with every contact
  def self.update
    all_contacts = Contact.all
    all_contacts.each do |contact|
      contact.get_most_recent_message
    end
  end

  #Get five most recent tweets or dms
  def get_most_recent_messages
    message_list = []
    #Check if email exists for contact
    if google_id
      message_list += get_email
    end

    #Check if the user is synched with twitter
    if user.token
      message_list += get_dms(user.twitter_client)
    end

    if message_list.length > 0
      sorted = potential_messages.sort_by{|message| message['time_stamp']}.reverse
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
  end

  #Get all emails to and from a contact
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

    else
      return []
    end
  end

  #Finds email id of most recent outbound email from user to contact
  def search_email(user_google_id, token)
    #search string
    query= "to:#{email}"
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

    #check if email body is string (could be image)
    message["snippet"] = email['snippet'].gsub("&lt;", "<").gsub("&gt;",">").gsub("&#39;", "'").gsub("&quot;", "\"")
    # message['snippet'] = snippet

    #hanles emails that have 1 part
    if email['payload']['body']['data'] != nil
      text = email['payload']['body']['data']
      message['text'] = Base64.decode64(text.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s
      return message

    #handles common two part email
    #parts[0] gives plaintext parts[1] gives html
    elsif email['payload']['parts'][0]['body']['data'].class == String

      plain = email['payload']['parts'][0]['body']['data']
      #Convert mimebase64 into utf8
      message['text'] = Base64.decode64(plain.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s

      html = email['payload']['parts'][1]['body']['data']
      if html != nil
        message['html'] = Base64.decode64(html.gsub("-", '+').gsub("_","/")).force_encoding("utf-8").to_s
      end
      return message

    else
      #handles non-text interactions
      message['text'] = "Image Sent"
      message['snipet'] = "Image"
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
  def twenty_nine_days?
    message = messages.first
    #days since last interaction
    days_since = ((message.time_stamp - Time.now.to_i)/86400.0).floor
    if days_since == 29
      return true
    else
      return false
    end
  end

  #check if you havent talked to your contact for 30 days
  def thirty_days?
    message = messages.first
    #days since last interaction
    days_since = ((message.time_stamp - Time.now.to_i)/86400.0).floor
    if days_since == 30
      return true
    else
      return false
    end
  end

  #update reminder for each contact
  def update_reminder
    #Time since last contact
    time_difference = (DateTime.now.strftime('%s').to_i) - (messages.order(time_stamp: :desc).first)
    #Status of interactions
    message_type = ( ((time_difference/86400) < 30) ? 'upcoming' : 'overdue')
    #Check if you should update an existing reminder or create a new one
    if (time_difference/86400) > 4
      if reminders == []
        Reminder.create(contact_id:id, reminder_type:message_type, message:messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:user_id)
      else
        reminders.first.update(contact_id:id, reminder_type:message_type, message:messages.first.body_plain_text, time_since_last_contact:(time_difference/86400), user_id:user_id)
      end
    end
  end
end
