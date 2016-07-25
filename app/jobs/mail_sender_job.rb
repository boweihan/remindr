class MailSenderJob < ActiveJob::Base
  queue_as :default

  def perform(google_id, receiver, subject, body, user)
    Message.send_mail(google_id, receiver, subject, body ,user)
    puts "SENT MAIL"
  end
end
