require 'spec_helper'

describe GameController do

  describe "GET 'index', teacher without game" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
    end

    it "returns http success " do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'index', user without games" do
    before :each do
      @user = User.make!
      sign_in @user
    end

    it "returns http success " do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'index', teacher with trivia" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
    end

    it "returns http success " do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'game_results'" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
    end

    it "returns http success " do
      get 'game_results', {:id => @game.id}
      expect(response).to be_success
    end
  end

  describe "GET 'games_played'" do
    render_views
    before :each do
      @teacher = Teacher.make!
      @user = User.make!
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
      @user.games << @game
      sign_in @user
    end

    it "returns http success " do
      get 'index'
      expect(response).to be_success
    end

    it "has the trivia with title" do
      get 'index'
      expect(response.body).to match(@user.games.first.trivia.title)
    end
  end

  describe "GET 'games_played_not_logged_in'" do
    before :each do
      get 'index'
    end

    it "redirects to root_path" do
      expect(response).to redirect_to root_path
    end

    it "shows an error message " do
      expect(flash[:error]).to eq ("Para ver los juegos debe logearse")
    end

  end

end