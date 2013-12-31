class AddTriviaToQuestion < ActiveRecord::Migration
  def change
    add_reference :questions, :trivia, index: true
  end
end
