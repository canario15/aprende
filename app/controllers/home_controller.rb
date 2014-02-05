class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @trivium = Trivia.all
  end
end
