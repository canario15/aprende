require 'spec_helper'

describe Game do

  describe "attributes" do
    it { should respond_to(:score) }
    it { should respond_to(:status) }
    it { should respond_to(:user_id) }
    it { should respond_to(:trivia_id) }
  end

  describe "relations" do
    it { should respond_to(:user) }
    it { should respond_to(:trivia) }
    it { should have_many(:answers) }
    it { should have_many(:questions) }
  end

  describe "Starting a new game" do
    before :each do
      question_1 = Question.make!(:one)
      question_2 = Question.make!(:two)
      @user = User.make!
    end

    it "starts a new game from a user" do
      expect{Game.create_game(@user)}.to change{Game.count}.by(1)
    end

    it "starts an empty game" do
      game = Game.create_game @user
      expect(game.questions).to be_empty
    end
  end

  describe "playing the game" do

    let!(:question_default) { Question.make!(:one) }

    before :each do
      @question_1 = Question.make!(description: 'who?', answer: 'You')
      @question_2 = Question.make!(description: 'Really, who?', answer: 'Me')
      @user = User.make!
      @game = Game.create_game(@user)
    end

    it "gets a new question" do
      made_questions = @game.questions
      question = @game.new_question
      expect(question).to_not be_nil
      expect(made_questions).to_not include(question)
    end

    it "evaluates a wrong answer responding false" do
      answer = "Me"
      res = @game.eval_answer(@question_1, answer)
      expect(res).to be false
    end

    it "evaluates a right answer responding true" do
      answer = "Me"
      res = @game.eval_answer(@question_2, answer)
      expect(res).to be true
    end

    it "evaluates a wrong answer not changing the score" do
      answer = "Me"
      expect{ @game.eval_answer(@question_1, answer) }.
        to change{@game.score}.
        by(0)
    end

    it "evaluates a right answer changing the score" do
      answer = "Me"
      expect{ @game.eval_answer(@question_2, answer) }.
        to change{@game.score}.
        by(Game::POINTS[@question_1.dificulty])
    end

    it "evalueates answer and create Answer" do
      answer = "Me"
      expect {@game.eval_answer(@question_2, answer)}.to change{Answer.count}.by(1)
    end

    it "finishes the game" do
      expect{@game.finish}.to change{@game.status}.to(Game::STATUS[:finished])
    end

    it "abort the game" do
      expect{@game.abort}.to change{@game.status}.to(Game::STATUS[:aborted])
    end
  end

end
