class AddTitleToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_title, :text
  end
end
