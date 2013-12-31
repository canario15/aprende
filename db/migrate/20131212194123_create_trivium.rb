class CreateTrivium < ActiveRecord::Migration
  def change
    create_table :trivium do |t|
      t.string :title
      t.text :tag
      t.text :description
      t.references :course, index: true

      t.timestamps
    end
  end
end
