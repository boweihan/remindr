class ChangeTypeToReminderType < ActiveRecord::Migration
  def change
    remove_column :reminders, :type
    add_column :reminders, :reminder_type, :string
  end
end
