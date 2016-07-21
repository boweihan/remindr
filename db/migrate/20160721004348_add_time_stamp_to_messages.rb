class AddTimeStampToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :time_stamp, :integer
  end
end
