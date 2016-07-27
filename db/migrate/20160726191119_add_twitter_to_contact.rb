class AddTwitterToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :twitter, :integer
  end
end
