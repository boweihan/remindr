class RemindersController < ApplicationController
  def show
    @reminder = Reminder.find(params[:id])
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    if @reminder.save
      redirect_to newsfeed_path
    else
      render :new
    end
  end

  def update
    @reminder = Reminder.find(params[:id])
    if @reminder.update_attributes(reminder_params)
      redirect_to newsfeed_path
    else
      render :edit
    end
  end

  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy
    redirect_to newsfeed_path
  end

  private
  def reminder_params
    params.require(:reminder).permit(:contact_id, :type, :message, :time_since_last_contact)
  end
end