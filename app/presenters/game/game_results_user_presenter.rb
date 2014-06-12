class Game::GameResultsUserPresenter
  def initialize(game)
    @game = game
  end

  def game
    @game
  end

  def trivia_game
    @game.trivia
  end

  def game_answers
    @game.answers
  end

  def game_questions
    @game.trivia.questions
  end

  def game_teacher
    @game.trivia.teacher
  end

  def trivium
    @game.trivia.course.trivium.with_questions_and_limit
  end
end