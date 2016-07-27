class MessagesController < ApplicationController
  before_action :ensure_logged_in
  def index
    @messages = Message.all
  end

  def create_direct_message
    current_user.twitter_client.direct_message_create(direct_messages_params[:user], direct_messages_params[:text])
  end

  def create_tweet
  current_user.twitter_client.update(tweet_params[:message])
  end

  def send_mail
    MailSenderJob.perform_later(current_user.google_id,params[:receiver], params[:subj], params[:bod])
    flash[:alert] = "Your email has been sent!"
    redirect_to newsfeed_url
  end
  #there probably doesn't need to be anything in here?

  private
   def direct_messages_params
     params.require(:direct_message).permit(:user, :text)
   end

   def tweet_params
     params.require(:tweet).permit(:message)
   end

end
