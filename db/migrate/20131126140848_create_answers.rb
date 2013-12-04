class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, index: true
      t.references :game, index: true
      t.boolean :was_correct
      t.string :answer

      t.timestamps
    end
  end
end
