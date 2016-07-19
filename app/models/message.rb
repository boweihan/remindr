class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user

  def self.api
    #this method needs to assign user_id, contact_id, and parameters to a new message object and save it
  end

end
