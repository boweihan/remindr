class TwitterLoadFeedJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.contacts.each do |contact|
      contact.get_dms(user.twitter_client)
    end
  end
end
