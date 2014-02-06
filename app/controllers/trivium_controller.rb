class TriviumController < ApplicationController
  before_filter :authenticate_teacher!
  layout 'application'

  def index
    if current_teacher
      @trivias = current_teacher.trivium
    else
      @trivias = []
    end
  end

  def new
    @trivia = Trivia.new
    @levels = Level.all
    @types = Trivia::TYPES
    @courses = @levels.first.try(:courses)
  end

  def update_course
    @courses = Level.find(params[:level_id]).courses

    render :json => { :courses => @courses}
  end

  def create
    @trivia =Trivia.new(trivia_params.merge(teacher: current_teacher))
    if @trivia.save
      respond_to do |format|
        format.html { redirect_to new_question_trivia_url(@trivia.id) }
      end
    else
      @levels = Level.all
      @types = Trivia::TYPES
      @courses = Level.find(params[:trivia_level]).courses

      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit
    @trivia = Trivia.find(params[:id])
    @levels = Level.all
    @types = Trivia::TYPES
    @courses = @trivia.level_courses
  end

  def update
    @trivia = Trivia.find(params[:id])
    if @trivia.update_attributes(trivia_params)
      respond_to do |format|
        format.html { redirect_to new_question_trivia_url(@trivia.id) }
      end
    else
      @levels = Level.all
      @types = Trivia::TYPES
      @courses = Level.find(params[:trivia_level]).courses

      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def new_question
    @trivia = Trivia.find(params[:id])
    @question = Question.new
    @questions = @trivia.questions
  end

  def create_question
    trivia = Trivia.find(params[:id])
    question = Question.create(question_params.merge({trivia_id: trivia.id}))
    respond_to do |format|
      if (params[:finish] == "true")
        format.html { redirect_to trivium_url }
      else
        format.html { redirect_to new_question_trivia_url(trivia.id) }
      end
    end
  end

  def edit_question
    @question = Question.find(params[:question_id])
    @trivia = @question.trivia
  end

  def update_question
    question = Question.find(params[:question_id])
    question.update_attributes(question_params)
    respond_to do |format|
      if (params[:finish] == "true")
        format.html { redirect_to trivium_url }
      else
        format.html { redirect_to new_question_trivia_url(question.trivia.id) }
      end
    end
  end

  private

  def trivia_params
    params.require(:trivia).permit(:title, :course_id, :tag, :description,:type)
  end

  def question_params
    params.require(:question).permit(:answer, :dificulty, :description, :image, :incorrect_answer_one, :incorrect_answer_two, :incorrect_answer_three, :incorrect_answer_four)
  end
end