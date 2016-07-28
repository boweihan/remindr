class RemoveColumnsFromUserAndContact < ActiveRecord::Migration
  def change
    remove_column :contacts, :twitter
    remove_column :users, :uid
    remove_column :users, :twitter
    remove_column :users, :url
  end
end
