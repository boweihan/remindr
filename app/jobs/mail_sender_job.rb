class MailSenderJob < ActiveJob::Base
  queue_as :default

  def perform(user, receiver, subject, body)
    Misc.send_mail(user, receiver, subject, body)
  end
end
