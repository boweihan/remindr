class RemoveColumnFromUsersandAddtoContact < ActiveRecord::Migration
  def change
    remove_column :users, :category, :string
    add_column :contacts, :category, :string
  end
end
