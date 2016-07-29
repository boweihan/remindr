class ChangeTimeFormatInReminders < ActiveRecord::Migration
  def change
    change_column :reminders, :time_since_last_contact, 'integer USING CAST(time_since_last_contact AS integer)'
  end
end
