class MessagesController < ApplicationController
  before_action :ensure_logged_in

  def create_direct_message
    current_user.twitter_client.create_direct_message(direct_messages_params[:user], direct_messages_params[:text])
    head :ok
  end

  #same as the above method, but useable when you want to send automated messages
  def create_direct_message_auto(user, text)
    current_user.twitter_client.direct_message_create(user, text)
    head :ok
  end

  def create_tweet
    current_user.twitter_client.update(tweet_params[:message])
    head :ok
  end

  def send_mail
    MailSenderJob.perform_later(current_user,params[:receiver], params[:subj], params[:bod])
    head :ok
  end

  private
   def direct_messages_params
     params.require(:direct_message).permit(:user, :text)
   end

   def tweet_params
    #  params.require(:tweet).permit(:message, :snippet)
    params.require(:tweet).permit(:message)
   end
end
