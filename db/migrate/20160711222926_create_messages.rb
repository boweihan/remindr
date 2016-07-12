class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.timestamps null: false
    end
  end
end
