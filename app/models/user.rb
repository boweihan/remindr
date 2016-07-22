class User < ActiveRecord::Base
  has_secure_password
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true

  has_many :contacts
  has_many :messages, through: :contacts

  def get_email(token)
    url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{token}"
    user_json = RestClient.get(url)
    email = JSON.parse(user_json)['email']
    self.google_id = email
    self.save
  end

  def self.check
    all_users = User.all
    all_users.each do |user|
      user.remind(user)
      puts "in user check loop"
    end
  end

  def remind(user)
    self.contacts.each do |contact|
      if contact.neglected?
        #Send email from self.email to contact.email using
        subj = 'Sorry for not talking to you for so long'
        bod = 'ER MA GURD'
        Message.send_email(user.google_id, contact.email, subj, bod, user)
      end
    end
  end

end
