class User < ActiveRecord::Base
  has_secure_password
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true

  has_many :contacts
  has_many :messages, through: :contacts
end
