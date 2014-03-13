class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :trivia
  has_many :answers
  has_many :questions, through: :trivia
  scope :finished ,-> { where(status: Game::STATUS[:finished]) }

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

  def self.create_game(user, trivia)
    create(user: user, score: 0, trivia_id: trivia.id, status: STATUS[:created])
  end

  def new_question(answereds,trivia)
    question = nil
    mark_as_started if self.status == STATUS[:created]
    count = trivia.questions.count
    questions = trivia.questions.map{|q| q.id} - answereds.map { |a| a.to_i}
    if count == answereds.count || questions.empty?
      finish
      return nil
    end
    while !question
      random_id = questions.sample
      question = Question.find(random_id)
    end
    question
  end

  def eval_answer(question_id, answer_text)
    question = Question.find(question_id)
    resp = validate_answer?(question.answer, answer_text)
    answer = Answer.new(question: question, game: self, answer: answer_text)
    if resp
      answer.was_correct = true
      self.score += POINTS[question.dificulty]
      self.save!
    else
      answer.was_correct = false
    end
    answer.save
    answer
  end

  def to_s
    self.score
  end

  def finish
    self.status = Game::STATUS[:finished]
    save!
  end

  def abort
    self.status = Game::STATUS[:aborted]
    save!
  end

  def correct_answers
    answers.where(:was_correct => true)
  end

  def self.week_ago_group_by_trivia
    Game.joins(:answers,:trivia).
    finished.
    where("games.updated_at >=?", 1.week.ago).
    select("games.id",
      "count(answers.id) as count_answers",
      "sum(answers.was_correct='t') as count_answers_was_correct",
      :trivia_id,
      "trivium.title as trivia_title",
      "count(DISTINCT games.id) as count_games",
      "avg(score) as avg_score").
    group(:trivia_id)
  end

  private

  def mark_as_started
    self.status = STATUS[:started]
    self.save
  end

  def transform_answer(answer)
    answer.downcase
  end

  def validate_answer?(correct_answer, user_answer)
    transform_answer(correct_answer) == transform_answer(user_answer)
  end
end
