require 'spec_helper'

describe Game do

  describe "Starting a new game" do
    before :each do
      @user = User.create(email: "am@vairix.com", password: "1234567890", password_confirmation: "1234567890")
    end

    it "starts a new game from a user" do
      expect{Game.start_game(@user)}.to change{Game.count}.by(1)
    end

  end

  describe "playing the game" do

    before :each do
      @user = User.create(email: "am@vairix.com", password: "1234567890", password_confirmation: "1234567890")
      @game = Game.start_game(@user)
    end

    it "gets a new question" do
      made_questions = @game.questions
      question = @game.new_question
      expect(made_questions).to_not include(question)
    end

    it "evaluates an answer" do
      pending
    end

    it "finishes the game" do
      pending
    end

    it "resets the game" do
      pending
    end
  end

end
