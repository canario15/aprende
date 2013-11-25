class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :description
      t.integer :dificulty
      t.binary :image
      t.string :answer

      t.timestamps
    end
  end
end
