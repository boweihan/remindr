class AddTwitterUserNameField < ActiveRecord::Migration
  def change
    add_column :contacts, :twitter_username, :string
  end
end
