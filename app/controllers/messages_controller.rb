class MessagesController < ApplicationController
  before_action :ensure_logged_in

  #ajax email send
  def send_mail
    MailSenderJob.perform_later(current_user.google_id,params[:receiver], params[:subj], params[:bod])
    head :ok, content_type: "text/html"
  end
end
