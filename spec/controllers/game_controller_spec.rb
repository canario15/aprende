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

end