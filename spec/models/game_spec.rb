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
      @trivia = Trivia.make!
      question_1 = Question.make!(:one, trivia: @trivia)
      question_2 = Question.make!(:two, trivia: @trivia)
      @user = User.make!
    end

    it "starts a new game from a user" do
      expect{Game.create_game(@user,@trivia)}.to change{Game.count}.by(1)
    end

    it "starts an empty game" do
      game = Game.create_game(@user,@trivia)
      expect(game.answers).to be_empty
    end
  end

  describe "playing the game" do

    let!(:question_default) { Question.make!(:one) }

    before :each do
      @trivia = Trivia.make!
      @question_1 = Question.make!(description: 'who?', dificulty: 1, answer: 'You', trivia: @trivia)
      @question_2 = Question.make!(description: 'Really, who?', dificulty: 1, answer: 'Me', trivia: @trivia)
      @user = User.make!
      @game = Game.create_game(@user,@trivia)
    end

    it "gets a new question" do
      made_questions = @game.answers.map{|a| a.question}
      question = @game.new_question(made_questions.map{|q| q.id.to_s}, @game.trivia)
      expect(question).to_not be_nil
      expect(made_questions).to_not include(question)
    end

    it "evaluates a wrong answer, was_correct false" do
      answer = "Me"
      res = @game.eval_answer(@question_1.id, answer)
      expect(res.was_correct).to be false
    end

    it "evaluates a right answer, was_correct true" do
      answer = "Me"
      res = @game.eval_answer(@question_2.id, answer)
      expect(res.was_correct).to be true
    end

    it "evalueates answer and create Answer" do
      answer = "Me"
      expect{@game.eval_answer(@question_1.id, answer)}.to change{Answer.count}.by(1)
    end

    it "evaluates a wrong answer not changing the score" do
      answer = "Me"
      expect{ @game.eval_answer(@question_1.id, answer) }.
        to change{@game.score}.
        by(0)
    end

    it "evaluates a right answer changing the score" do
      answer = "Me"
      expect{ @game.eval_answer(@question_2.id, answer) }.
        to change{@game.score}.
        by(Game::POINTS[@question_1.dificulty])
    end

    it "finishes the game" do
      expect{@game.finish}.to change{@game.status}.to(Game::STATUS[:finished])
    end

    it "abort the game" do
      expect{@game.abort}.to change{@game.status}.to(Game::STATUS[:aborted])
    end

    it "counts just one correct answer" do
      answer = "Me"
      res_false = @game.eval_answer(@question_1.id, answer)
      res_true = @game.eval_answer(@question_2.id, answer)
      correct_answers = @game.correct_answers
      expect(correct_answers.count).to be 1
    end

    it "counts just two correct answers" do
      answer = "You"
      res_false = @game.eval_answer(@question_1.id, answer)
      answer = "Me"
      res_true = @game.eval_answer(@question_2.id, answer)
      correct_answers = @game.correct_answers
      expect(correct_answers.count).to be 2
    end
  end


  describe "Week ago group by trivia" do
    before :each do
      (1..4).each do |index_t|
        teacher = Teacher.make!
        user = User.make!
        user.confirm!
        trivia = Trivia.make!(teacher: teacher)

        (1..4).each do |index_g|
          question = Question.make!(trivia:trivia)
          game = Game.make!(trivia: trivia, score: 100.0)
          Answer.make!(game:game, question: question, was_correct: true)
          game.finish
          user.games << game
        end
      end
    end
    let(:games){ Game.week_ago_group_by_trivia }

    describe "games" do
      it "all games in this weeks" do
        expect(games.length).to eq(4)
      end

      it "half of the games in this week" do
        Game.all.each_slice(8).first.each do |g|
          g.update(updated_at: 1.week.ago)
        end
        expect(games.length).to eq(2)
      end


      it "even games in this week" do
        Game.all.each_with_index do |g,index|
          g.update(updated_at: 1.week.ago)  if index.even?
        end
        expect(games.length).to eq(4)
      end


      it "empty games in this week" do
        Game.all.each do |g|
          g.update(updated_at: 1.week.ago)
        end
        expect(games.length).to eq(0)
      end
    end

    describe "counts games" do
      it "all games in this weeks" do
        games.each do |g|
          expect(g.count_games).to eq(4)
        end
      end

      it "half of the games in this week" do
        Game.all.each_slice(8).first.each do |g|
          g.update(updated_at: 1.week.ago)
        end
        games.each do |g|
          expect(g.count_games).to eq(4)
        end
      end

      it " even games in this week" do
        Game.all.each_with_index do |g,index|
          g.update(updated_at: 1.week.ago)  if index.even?
        end
        games.each do |g|
          expect(g.count_games).to eq(2)
        end
      end
    end

    describe "average score" do
      it "all games in this weeks" do
        games.each do |g|
          expect(g.avg_score).to eq(100.0)
        end
      end

      it "half of the games in this week" do
        Game.all.each_slice(8).first.each do |g|
           g.update(answers: [])
        end
        games.each do |g|
          expect(g.avg_score).to eq(100.0)
        end
      end

      it "even games in this week" do
        Game.all.each_with_index do |g,index|
           g.update(answers: [])  if index.even?
        end
        games.each do |g|
          expect(g.avg_score).to eq(100.0)
        end
      end
    end

    describe "count answers" do
      it "all games in this weeks" do
        games.each do |g|
          expect(g.count_answers).to eq(4)
        end
      end

      it "half of the games in this week" do
        Game.all.each_slice(8).first.each do |g|
           g.update(answers: [])
        end
        games.each do |g|
          expect(g.count_answers).to eq(4)
        end
      end

      it "even games in this week" do
        Game.all.each_with_index do |g,index|
           g.update(answers: [])  if index.even?
        end
        games.each do |g|
          expect(g.count_answers).to eq(2)
        end
      end
    end

    describe "count answers was correct" do
      it "all games in this weeks" do
        games.each do |g|
          expect(g.count_answers_was_correct).to eq(4)
        end
      end

      it "half of the games in this week" do
        result = Game.all.each_slice(4).to_a
        [result[0],result[2]].each do |array|
          array.each do |g|
            g.answers.first.update(was_correct: false)
          end
        end
        games.each_with_index do |g,index|
          value = index.even? ? 0:4
          expect(g.count_answers_was_correct).to eq(value)
        end
      end

      it "even games in this week" do
        Game.all.each_with_index do |g,index|
          g.answers.first.update(was_correct: false)  if index.even?
        end
        games.each do |g|
          expect(g.count_answers_was_correct).to eq(2)
        end
      end
    end
  end
end
