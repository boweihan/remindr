class AddColumntoUser < ActiveRecord::Migration
  def change
    add_column :users, :reach_out_platform, :string
  end
end
