class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @q = Trivia.search(params[:q])
    @trivium = @q.result(distinct: true)
  end
end
