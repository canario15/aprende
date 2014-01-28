class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :trivia
  has_many :answers
  has_many :questions, through: :answers

  STATUS = {
    :created => 1,
    :started => 2,
    :finished => 3,
    :aborted => 4
  }

  #POINTS depends on difficulty
  POINTS = {
    1 => 100,
    2 => 300,
    3 => 500,
    4 => 800,
    5 => 1500
  }

  def self.create_game(user)
    self.create(user: user, score: 0, status: 1)
  end

  def new_question
    mark_as_started if self.status == STATUS[:created]
    answered = questions.map { |q| q.id }.join(',')
    unless answered.empty?
      possible_questions = Question.where("id not in (#{answered})")
    else
      possible_questions = Question.all
    end
    random_question = rand(possible_questions.size)
    possible_questions[random_question]
  end

  def eval_answer(question, answer)
    right_answer = transform_answer question.answer
    user_answer  = transform_answer answer
    resp = right_answer == user_answer
    if resp
      self.score += POINTS[question.dificulty]
      self.save!
    end
    resp
  end

  def finish
    self.status = Game::STATUS[:finished]
    save!
  end

  def abort
    self.status = Game::STATUS[:aborted]
    save!
  end

  private

  def mark_as_started
    self.status = STATUS[:started]
    self.save
  end

  def transform_answer(answer)
    answer.downcase
  end
end
