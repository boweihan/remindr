class RemindersController < ApplicationController
  before_action :ensure_logged_in

  #reminder crud actions
  def index
    @type = current_user.reminder_platform
    @types = ['Email', "Twitter", "Text"]
    @reminders = Reminder.where(user_id:current_user.id).order(time_since_last_contact: :desc)
  end


  def change_type
    if request.xhr?
      @user = current_user
      User.update(@user.id, reminder_platform: params[:type])
      head(:ok)
    else
      not_found
    end
  end
end
