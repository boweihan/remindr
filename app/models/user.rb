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
      user.remind
      puts "in user check loop"
    end
  end

  def remind
    self.contacts.each do |contact|
      if contact.neglected?
        puts "#{contact.name} is overdue"
      end
    end
  end

end
