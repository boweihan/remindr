class AddPlainTextToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :body_plain_text, :text
  end
end
