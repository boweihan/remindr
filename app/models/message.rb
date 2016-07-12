class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user
end
