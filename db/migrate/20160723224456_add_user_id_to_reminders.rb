class AddUserIdToReminders < ActiveRecord::Migration
  def change
    add_reference :reminders, :user, index:true
    add_foreign_key :reminders, :users
  end
end
