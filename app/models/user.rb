class User < ActiveRecord::Base
  #bcrypt method
  has_secure_password

  #validations
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true

  #ActiveRecord associations
  has_many :contacts
  has_many :messages, through: :contacts
  has_many :reminders, through: :contacts


  #find the google-email adress on sign-in b/c user email !=  (always) their gmail
  #it is run everytime on login because the user could sign into different email accounts
  def get_email_address(token)
    #see if token has expired
    check_token
    #Get the email adress in json
    url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{token}"
    user_json = RestClient.get(url)
    email = JSON.parse(user_json)['email']
    #save record in db
    self.google_id = email
    self.save
  end


# added this part starts
  def twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_consumer_key"]
      config.consumer_secret     = ENV["twitter_consumer_secret"]
      config.access_token        = self.token
      config.access_token_secret = self.secret
    end
    return client
  end


  def self.from_omniauth(auth_hash, current_user)
    current_user.uid = auth_hash['uid']
    current_user.provider = auth_hash['provider']
    current_user.name = auth_hash['info']['name']
    current_user.url = auth_hash['info']['urls']['Twitter']
    current_user.token = auth_hash['credentials']['token']
    current_user.secret = auth_hash['credentials']['secret']
    current_user.save!
    current_user
  end

  def tweet(tweet)
   client = Twitter::REST::Client.new do |config|
     config.consumer_key        = Rails.application.secrets.twitter_consumer_key
     config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
     config.access_token        = self.token
     config.access_token_secret = self.secret
   end
   client.update(tweet)
  end

  def self.get_direct_messages
    all.each do |user|
      user.contacts.each do |contact|
        contact.get_dms(user.twitter_client, user)
      end
    end
  end

  def get_email(token)
    self.check_token
    url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{token}"
    user_json = RestClient.get(url)
    email = JSON.parse(user_json)['email']
    self.google_id = email
    self.save
  end

  #class method that calls eamil_my_contacts on every contact
  def self.check
    all_users = User.all
    all_users.each do |user|
      #see if token is still valid
      user.check_token
      user.email_my_contacts
      puts "in user check loop"
    end
  end

  #email a user's contacts that have been neglected
  def email_my_contacts
    contacts.each do |contact|
      #check if you haven ttalke dto contact for 30 days
      if contact.neglected?
        #send email
        subj = 'Sorry for not talking to you for so long'
        bod = 'ER MA GURD'
        Misc.send_mail(self, contact.email, subj, bod)
      end
    end
  end

  #use refresh token to get new access token
  def refresh
    #post to url to get new token
    response = RestClient.post 'https://accounts.google.com/o/oauth2/token', :grant_type => 'refresh_token', :refresh_token => refresh_token, :client_id => ENV['CLIENT'], :client_secret => ENV['CLIENT_SECRET']
    refresh = JSON.parse(response.body)
    #store token
    access_token = refresh['access_token']
  end

  # check if the token is expired
  def check_token
    #check when token was stored
    issued_at_time = issued_at.strftime('%s')
    #check when it will expire. also added 60 second buffer for processing time
    issued_at_time = issued_at_time.to_i+3660
    expiry = DateTime.strptime(issued_at_time.to_s, '%s')
    #see if token has expired at this time
    if expiry < DateTime.now
      #get a new token
      refresh
    end
  end
end
