class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :score
      t.integer :status
      t.references :user, index: true

      t.timestamps
    end
  end
end
