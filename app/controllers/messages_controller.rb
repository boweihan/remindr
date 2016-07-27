class MessagesController < ApplicationController
  before_action :ensure_logged_in
  def index
    @messages = Message.all
  end

  def send_mail
    MailSenderJob.perform_later(current_user.google_id,params[:receiver], params[:subj], params[:bod])
    flash[:alert] = "Your email has been sent!"
    redirect_to newsfeed_url
  end
  #there probably doesn't need to be anything in here?
end
