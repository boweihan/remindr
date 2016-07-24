class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.belongs_to :contact, index: true, foreign_key: true
      t.string :type
      t.text :message
      t.datetime :time_since_last_contact

      t.timestamps null: false
    end
  end
end
