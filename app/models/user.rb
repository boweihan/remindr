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
