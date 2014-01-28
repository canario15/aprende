class AddTriviaToGame < ActiveRecord::Migration
  def change
    add_reference :games, :trivia, index: true
  end
end
