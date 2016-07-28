class UserLoadFeedJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.contacts.each do |contact|
      contact.get_most_recent_message
      contact.update_reminder
    end
  end
end
