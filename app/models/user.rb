class User < ActiveRecord::Base
  has_secure_password
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true

  has_many :contacts
  has_many :messages, through: :contacts
  has_many :reminders, through: :contacts

  def get_email(token)
    self.check_token
    url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{token}"
    user_json = RestClient.get(url)
    email = JSON.parse(user_json)['email']
    self.google_id = email
    self.save
  end

  def self.check
    all_users = User.all
    all_users.each do |user|
      user.check_token
      user.remind
      puts "in user check loop"
    end
  end

  def remind
    self.contacts.each do |contact|
      if contact.neglected?
        #Send email from self.email to contact.email using
        subj = 'Sorry for not talking to you for so long'
        bod = 'ER MA GURD'
        Message.send_mail(self.google_id, contact.email, subj, bod, self)
      end
    end
  end

  def refresh
    response = RestClient.post 'https://accounts.google.com/o/oauth2/token', :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => ENV['CLIENT'], :client_secret => ENV['CLIENT_SECRET']
    refresh = JSON.parse(response.body)
    current_user.access_token = refresh['access_token']
  end

  # check if the token is expired
  def check_token
    issued_at_time = self.issued_at.strftime('%s')
    issued_at_time = issued_at_time.to_i+3600
    expiry = DateTime.strptime(issued_at_time.to_s, '%s')
    if expiry < DateTime.now
      self.refresh
    end
  end
end
