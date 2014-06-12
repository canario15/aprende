class TriviumController < ApplicationController
  before_filter :authenticate_teacher!

  def index
    if current_teacher
      @trivias = current_teacher.trivium
    else
      @trivias = []
    end
  end

  def new
    @trivia = Trivia.new
    @types = Trivia::TYPES
    @courses = Course.all
  end

  def update_course
    @courses = Course.all
    render :json => { :courses => @courses}
  end

  def create
    @trivia = Trivia.new(trivia_params.merge(teacher: current_teacher))
    if @trivia.save
      respond_to do |format|
        format.html { redirect_to new_question_trivia_url(@trivia.id) }
      end
    else
      @types = Trivia::TYPES
       @courses = Course.all
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit
    @trivia = Trivia.find(params[:id])
    @types = Trivia::TYPES
    @courses = Course.all
  end

  def update
    @trivia = Trivia.find(params[:id])
    trivia_with_no_games = @trivia.with_no_games?
    if trivia_with_no_games && @trivia.update_attributes(trivia_params)
      respond_to do |format|
        format.html { redirect_to new_question_trivia_url(@trivia.id) }
      end
    else
      @types = Trivia::TYPES
      @courses = Course.all
      flash.now[:alert] = "No se puede editar una trivia si tiene cuestionarios completados" unless trivia_with_no_games
      respond_to do |format|
        format.html { render :edit  }
      end
    end
  end

  def clone
    trivia = Trivia.find(params[:id])
    trivia_clone = trivia.clone_with_associations
    redirect_to trivium_url, notice: "Nueva trivia clonada: ", flash: { link: {title: trivia_clone.title,url: edit_trivia_path(trivia_clone)}}
  end

  def new_question
    @trivia = Trivia.find(params[:id])
    @question = Question.new
    @questions = @trivia.questions
  end

  def create_question
    @trivia = Trivia.find(params[:id])
    @question = Question.new(question_params.merge({trivia_id: @trivia.id}))
    respond_to do |format|
      trivia_with_no_games = @question.trivia.with_no_games?
      if trivia_with_no_games && @question.save
        if (params[:finish] == "true")
          format.html { redirect_to trivium_url }
        else
          format.html { redirect_to new_question_trivia_url(@trivia.id) }
        end
      else
        @questions = @trivia.questions
        format.html { render :new_question }
        flash.now[:alert] = "No se puede crear una pregunta si su trivia tiene cuestionarios completados" unless trivia_with_no_games
      end
    end
  end

  def edit_question
    @question = Question.find(params[:question_id])
    @trivia = @question.trivia
  end

  def update_question
    @question = Question.find(params[:question_id])
    respond_to do |format|
      trivia_with_no_games = @question.trivia.with_no_games?
      if trivia_with_no_games && @question.update_attributes(question_params)
        if (params[:finish] == "true")
          format.html { redirect_to trivium_url }
        else
          format.html { redirect_to new_question_trivia_url(@question.trivia.id) }
        end
      else
       @trivia = @question.trivia
       format.html { render :edit_question }
       flash.now[:alert] = "No se puede editar una pregunta si su trivia tiene cuestionarios completados" unless trivia_with_no_games
      end
    end
  end

  private

  def trivia_params
    params.require(:trivia).permit(:title, :course_id, :tag, :description, :type, content_attributes: [:id, :containable_type, containable_attributes: [:document, :id]])
  end

  def question_params
    params.require(:question).permit(:answer, :dificulty, :description, :image, :incorrect_answer_one, :incorrect_answer_two, :incorrect_answer_three, :incorrect_answer_four)
  end
end