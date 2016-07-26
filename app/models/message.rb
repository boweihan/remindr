class Message < ActiveRecord::Base
  #ActiveRecord associations
  belongs_to :contact
  belongs_to :user

  def self.send_mail(sender, receiver, subj, bod, user)
    user_input = Mail.new do
      from sender
      to receiver
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


  #Summarizes the message body for display
  def summary
    message = body_plain_text
    message.slice(0,250)+"...."
  end

  def check_sentiment
    text = body_plain_text
    alchemyapi = AlchemyAPI.new()
    response = alchemyapi.sentiment("text", text)

    if response['docSentiment']['score'] != nil && response["docSentiment"]["type"] != 'neutral'
      return "Score: " + response['docSentiment']['score'] + " Sentiment: " + response["docSentiment"]["type"]
    end
    "Sentiment: " + response["docSentiment"]["type"]
  end

  def easytoner
      message = body_plain_text..gsub(/[^0-9a-z ]/i, '')
      if message == nil
        return "Message is not in ASCII Format"
      else
        analysis = Easytone::ToneGen.tone(ENV["CLIENT_TONE"], ENV["CLIENT_TONE_SECRET"], message)
        return "Your message breakdown is #{analysis}"
      end
  end

  def self.check_sentiment_all_messages
    array = []
    all.each do |message|
      if message.body_plain_text != nil
        myText = message.body_plain_text
        array << message.check_sentiment
      end
    end
    array
  end
end
