class AddSnippetToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :snippet, :text
  end
end
