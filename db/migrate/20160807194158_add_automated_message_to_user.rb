class AddAutomatedMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :automated_message, :text
  end
end
