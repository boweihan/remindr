class ChangeTwitterToString < ActiveRecord::Migration
  def change
    change_column :contacts, :twitter, :string
  end
end
