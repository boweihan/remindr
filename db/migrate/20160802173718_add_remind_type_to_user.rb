class AddRemindTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :reminder_platform, :string
  end
end
