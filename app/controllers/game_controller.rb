class GameController < ApplicationController
  before_filter :authenticate_teacher!, only: [:index_teacher,:game_results_teacher]
  before_filter :authenticate_user!, only:[:new, :create, :eval_answer,:index_user,:game_results_user]

  def new
    set_trivia
    reset_game
  end

  def create
    set_trivia
    new_game
    @game = Game.create_game(current_user,@trivia)
    save_game(@game.id)
    game_statics
    render :eval_answer
  end

  def eval_answer
    set_game
    question_id = params[:question_id]
    unless question_answered?(question_id)
      save_answered_question(question_id)
      select_answer = params[:select_answer]
      @answer = @game.eval_answer(question_id,select_answer)
      @show_answer = true
    end
    set_trivia
    game_statics
    if @question.nil?
      @finish = true
      flash.now[:finish] = "Ya ha respondido todas las preguntas!! Su puntaje fue: #{@game.score}"
      render :finish
    end
  end

  def reset
    reset_game
    redirect_to action: :new
  end

  def index_teacher
    @games_results = current_teacher.games_finished
  end

  def index_user
    @games_results = current_user.games_finished.order(updated_at: :desc)
  end

  def game_results_teacher
    @game = Game.find(params[:id])
    @game_answers = @game.answers
  end

  def game_results_user
    @presenter =  Game::GameResultsUserPresenter.new(Game.find(params[:id]))
  end

private

  def question_answered?(question_id)
    session[:answereds].include? question_id
  end

  def set_trivia
    @trivia = Trivia.find(params[:trivia_id])
  end

  def save_answered_question question_id
    session[:answereds] ||= []
    session[:answereds] << question_id
  end

  def answereds
    session[:answereds] ||= []
  end

  def get_game_id
    session[:game]
  end

  def save_game(game_id)
    session[:game] = game_id
  end

  def total_questions(trivia)
    if session[:total_questions] == 0
      session[:total_questions] = trivia.questions.count
    else
      session[:total_questions]
    end
  end

  def sum_score_answers(game)
    if session[:sum_score_answers] == 0
      session[:sum_score_answers] = game.sum_score_answers
    else
      session[:sum_score_answers]
    end
  end

  def game_statics
    @percent_score_answers = (@game.score.to_f / sum_score_answers(@game) * 100)
    @count_answereds = answereds.count + 1
    @total_questions = total_questions(@trivia)
    @game_progress = (answereds.count.to_f / @total_questions * 100)
    @question = @game.new_question(answereds,@trivia)
  end

  def reset_game
    session[:total_questions] = 0
    session[:sum_score_answers] = 0
    session[:answereds] = []
    session[:game] = nil
  end

  def set_game
    @game = Game.find(get_game_id) if get_game_id
  end
  alias_method :new_game, :reset_game

end
