class AddAnswerToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :incorrect_answer_one, :string
    add_column :questions, :incorrect_answer_two, :string
    add_column :questions, :incorrect_answer_three, :string
    add_column :questions, :incorrect_answer_four, :string
  end
end
