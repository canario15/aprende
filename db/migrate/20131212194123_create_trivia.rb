class CreateTrivia < ActiveRecord::Migration
  def change
    create_table :trivia do |t|
      t.string :title
      t.text :tag
      t.text :description
      t.references :course, index: true

      t.timestamps
    end
  end
end
