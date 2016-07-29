class MessagesController < ApplicationController
  before_action :ensure_logged_in


  #ajax email send
  def create_direct_message
    binding.pry
    current_user.twitter_client.direct_message_create(direct_messages_params[:user], direct_messages_params[:text])
    # head :ok, content_type: "text/html"
  end

  def create_tweet
    binding.pry
    current_user.twitter_client.update(tweet_params[:message])
    # head :ok, content_type: "text/html"
  end

  def send_mail
    MailSenderJob.perform_later(current_user,params[:receiver], params[:subj], params[:bod])
    head :ok, content_type: "text/html"
  end

  private
   def direct_messages_params
     params.require(:direct_message).permit(:user, :text)
   end

   def tweet_params
     params.require(:tweet).permit(:message)
   end
end
