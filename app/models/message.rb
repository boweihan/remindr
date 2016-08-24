class Message < ActiveRecord::Base
  #ActiveRecord associations
  belongs_to :contact
  belongs_to :user
end


  #check sentiment of a message
  # def check_sentiment
  #   text = body_plain_text
  #   alchemyapi = AlchemyAPI.new()
  #   #make api call
  #   response = alchemyapi.sentiment("text", text)
  #   #show sentiment if present
  #   if response['docSentiment']['score'] != nil && response["docSentiment"]["type"] != 'neutral'
  #     return "Score: " + response['docSentiment']['score'] + " Sentiment: " + response["docSentiment"]["type"]
  #   end
  #   "Sentiment: " + response["docSentiment"]["type"]
  # end

  #analysis of tone
  # def easytoner
  #   #conver to ascii
  #     message = body_plain_text.gsub(/[^0-9a-z ]/, '')
  #     if message == nil
  #       return "Message is not in ASCII Format"
  #     #return breakdown
  #     else
  #       analysis = Easytone::ToneGen.tone(ENV["CLIENT_TONE"], ENV["CLIENT_TONE_SECRET"], message)
  #       return "Your message breakdown is #{analysis}"
  #     end
  # end
  # #Check sentiment on all messages
  # def self.check_sentiment_all_messages
  #   array = []
  #   all.each do |message|
  #     if message.body_plain_text != nil
  #       myText = message.body_plain_text
  #       array << message.check_sentiment
  #     end
  #   end
  #   array
  # end
