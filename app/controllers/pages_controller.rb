class PagesController < ApplicationController
  before_action :ensure_logged_in, except: [:landing]

  #twitter callback after verification
  def twitter_callback
    @user = current_user.save_callback_info_twitter(request.env['omniauth.auth'])
    redirect_to newsfeed_path
  end

  #ask user if we can load google contacts
  def permission
  end

  # def analytics
  #   @messages = Message.all
  # end

  #click to import from twitter
  def twitter_sync
  end

  #oauth with google
  def googleauth
    auth_uri = Misc.load_google_client.authorization_uri.to_s
    redirect_to auth_uri
  end

  #After they are authenitcated with google
  def callback
    #if user clicks deny
    if params[:error]
      puts "error"

    #authcode in qs if user clicks allow access
    elsif params[:code]
      @auth_client = Misc.load_google_client
      @auth_client.code = params[:code]
      #exchange auth for token
      @auth_client.fetch_access_token!
      #save in db
      if @auth_client.refresh_token != nil
        current_user.update({access_token: @auth_client.access_token, refresh_token: @auth_client.refresh_token, issued_at: @auth_client.issued_at})
      else
        current_user.update({access_token: @auth_client.access_token, issued_at: @auth_client.issued_at})
      end
      current_user.get_email_address
    end

    if current_user.contacts.length > 0
      redirect_to newsfeed_path
    else
      redirect_to permission_path
    end
  end

  def import
    if request.xhr?
      @potential_contacts = current_user.google_contacts
      render json: @potential_contacts
    end
  end

  #newsfeed
  def newsfeed
    #new contact the form for new contact
    @contacts = current_user.contacts
  end

  #landing page
  def landing
    @user = User.new
  end

  def pull_messages
    current_user.update_newsfeed
    current_user.update_reminders
    respond_to do |format|
      format.js{}
    end
  end
end
