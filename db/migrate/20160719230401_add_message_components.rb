class AddMessageComponents < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :google_id, :string
    add_column :messages, :body, :text
  end
end
