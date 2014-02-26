class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :description
      t.string :title
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
