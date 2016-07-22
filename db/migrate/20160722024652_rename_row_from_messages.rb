class RenameRowFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :body
    add_column :messages, :body_html, :text
  end
end
