class PagesController < ApplicationController
  before_action :ensure_logged_in, except: [:landing]
  before_action :load_client, only: [:load_client, :googleauth, :callback]

  #twitter callback after verification
  def tweet_info
    @user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    TwitterLoadFeedJob.perform_later(current_user)
    redirect_to login_page_path
  end

  #create a new client for authentication
  def load_client
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.parse(ENV['GOOGLE_CLIENT_SECRETS']))
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/userinfo.email ' +
      'https://www.googleapis.com/auth/userinfo.profile '+
      'https://www.googleapis.com/auth/gmail.readonly '+
      'https://www.googleapis.com/auth/gmail.send '+
      'https://www.googleapis.com/auth/contacts.readonly',
      :redirect_uri => 'http://localhost:3000/callback'
        # :redirect_uri => 'http://remindr-me.herokuapp.com/callback'
      )
  end

  def analytics
    @messages = Message.all
  end

  #click to import from social media
  def login_page
  end

  #dashboard with calender and reminders
  def dashboard
  end

  #action hands user over to google
  def googleauth
      auth_uri = @auth_client.authorization_uri.to_s
      redirect_to auth_uri
  end

  #After they are authenitcated with google
  def callback
    #if user clicks deny
    if params[:error]
      puts "error"

    #authcode in qs if user clicks allow access
    elsif params[:code]
      @auth_client.code = params[:code]
      #exchange auth for token
      @auth_client.fetch_access_token!
      #save in db
      current_user.update({access_token: @auth_client.access_token, refresh_token: @auth_client.refresh_token, issued_at: @auth_client.issued_at})
      #find google email adress of account that was signed into google
      current_user.get_email_address
      #update feed in background
      # UserLoadFeedJob.perform_later(current_user)
    end
    #
    # unless current_user.contacts.length > 0
    #   redirect_to '/import_contacts'
    # end
    # redirect_to '/login_page'

    if current_user.contacts.length > 0
      redirect_to '/login_page'
    else
      redirect_to '/import_contacts'
    end

  end
  def import
    @potential_contacts = current_user.google_contacts
    render json: @potential_contacts if request.xhr?
  end
  #newsfeed
  def newsfeed
    #new contact the form for new contact
    @contact = Contact.new
    @contacts = current_user.contacts
    @reminders = Reminder.where(user_id:current_user.id).order(time_since_last_contact: :desc)
  end

  #landing page
  def landing
    @user = User.new
  end

  #update user message
  def update_message
    current_user.update_automated_message(params[:update])
  end


  def pull_messages
    current_user.contacts.each do |contact|
      contact.get_most_recent_message
      contact.update_reminder
    end
    head :ok
  end


end
