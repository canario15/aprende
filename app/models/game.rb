class Game < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :questions, through: :answers


  def self.start_game(user)
    self.create(user: user, score: 0, status: 0)
  end

  def new_question
  	answered = questions.map { |q| q.id  }

  end


  def new_question_controller
    question = nil
    count = Question.count
    if count == answereds.count
      return nil
    end
    while !question
      random_id = rand(count) + 1
      question = Question.find_by_id random_id unless answereds.include?(random_id)
    end
    question
  end
end
