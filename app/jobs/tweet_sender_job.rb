class DmSenderJob < ActiveJob::Base
  queue_as :default

  def perform(user, recipient, message)
    Misc.send_dm(user, recipient, message)
  end
end
