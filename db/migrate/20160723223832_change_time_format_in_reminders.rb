class ChangeTimeFormatInReminders < ActiveRecord::Migration
  def change
    change_column :reminders, :time_since_last_contact, :integer
  end
end
