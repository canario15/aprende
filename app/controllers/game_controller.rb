class GameController < ApplicationController
  before_filter :check_user_or_teacher_logged_in!, :only => [:index]
  before_filter :authenticate_user!, :only => [:new, :create, :eval_answer]

  def new
    set_trivia
    reset_game
  end

  def create
    set_trivia
    @game = Game.create_game(current_user,@trivia)
    save_game(@game.id)
    @question = @game.new_question(answereds,@trivia)
    @count_answereds = answereds.count + 1
    @total_questions = @trivia.questions.count
    render :eval_answer
  end

  def eval_answer
    question_id = params[:question_id]
    save_answered_question(question_id)
    select_answer = params[:select_answer]
    set_game
    @answer = @game.eval_answer(question_id,select_answer)
    @show_answer = true
    if @answer.was_correct
      flash[:notice] = "Ud. ha acertado!! Felicitaciones!"
    else
      flash[:notice] = "Respuesta equivocada :(. Siga intentando.."
    end
    set_trivia
    @count_answereds = answereds.count + 1
    @total_questions = @trivia.questions.count
    @question = @game.new_question(answereds,@trivia)
    if @question.nil?
      @finish = true
      flash[:finish] = "Ya ha respondido todas las preguntas!! Su puntaje fue: #{@game.score}"
      render :finish
    end
  end

  def reset
    reset_game
    redirect_to action: :new
  end

  def index
    if current_teacher
      @games_results = current_teacher.games
    end
    if current_user
      @games_results = current_user.games
    end
  end

  def game_results
    @game = Game.find(params[:id])
    @game_answers = @game.answers
  end

private

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

  def reset_game
    session[:answereds] = []
    session[:game] = nil
  end

  def set_game
    @game = Game.find(get_game_id) if get_game_id
  end

  def check_user_or_teacher_logged_in!
    if !teacher_signed_in? && !user_signed_in?
      flash[:error] = "Para ver los juegos debe logearse"
      redirect_to root_path
    end
  end

end
