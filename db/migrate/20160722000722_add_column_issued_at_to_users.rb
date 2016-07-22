class AddColumnIssuedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :issued_at, :datetime
  end
end
