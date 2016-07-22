class MessagesController < ApplicationController
  before_action :ensure_logged_in
  def index
    @messages = Message.all
  end

  def send_mail
    #this will be current_user.email eventually was Message.send_mail('bowei.han100@gmail.com', params[:receiver], params[:subj], params[:bod], current_user)
    Message.send_mail(current_user.google_id, params[:receiver], params[:subj], params[:bod], current_user)
    flash[:alert] = "Your email has been sent!"
    redirect_to newsfeed_url
  end
  #there probably doesn't need to be anything in here?
end
