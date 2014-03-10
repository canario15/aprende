class CreateWrittens < ActiveRecord::Migration
  def change
    create_table :writtens do |t|
      t.text :document
      t.timestamps
    end
  end
end