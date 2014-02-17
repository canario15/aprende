class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:search]
      @q_value = params[:search][:q]
      @trivium = Trivia.search_with_questions(@q_value)
    else
      @trivium = Trivia.with_questions
    end
  end
end
