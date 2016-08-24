class MessagesController < ApplicationController
  before_action :ensure_logged_in

  def create_direct_message
    if current_user.token
      head :bad_request
    else
      Misc.send_dm(current_user, direct_message_params[:user], direct_message_params[:text])
      head :ok
    end

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
