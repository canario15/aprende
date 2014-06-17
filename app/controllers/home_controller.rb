class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @trivium = Trivia.with_questions
    @courses = Course.system_courses(current_company)
    render 'home_responsive'
  end

  def search
    if params[:search]
      @q_value = params[:search][:q]
      @trivium = Trivia.search_with_questions(@q_value)
    else
      @trivium = Trivia.with_questions
    end
  end
end
