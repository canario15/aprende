class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:search]
      @q_value = params[:search][:q]
      @trivium = Trivia.search({teacher_city_name_or_teacher_first_name_or_teacher_last_name_or_title_or_tag_cont: @q_value}).result(distinct: true)
    else
      @trivium = Trivia.all
    end
  end
end
