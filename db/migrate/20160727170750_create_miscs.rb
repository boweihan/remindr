class CreateMiscs < ActiveRecord::Migration
  def change
    create_table :miscs do |t|

      t.timestamps null: false
    end
  end
end
