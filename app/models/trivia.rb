class Trivia < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :course
  belongs_to :teacher
  has_one :level, :through => :course
  has_many :questions
  has_many :games

  validates :title, :presence => true
  validates :course, :presence => true
  validates :type, :presence => true
  validates :teacher, :presence => true

  scope :with_questions, -> { joins(:questions).uniq }
  scope :with_questions_and_limit, -> { with_questions.limit(3) }
  scope :search_with_questions, -> (q){ search({teacher_city_name_or_teacher_first_name_or_teacher_last_name_or_title_or_tag_cont: q}).result(distinct: true).with_questions }
  TYPES = {1 => I18n.t('trivia.type.multiple_choice'), 2 => I18n.t('trivia.type.free')}

  TYPE_MULTIPLE_CHOICE = TYPES.keys.first

  def level_courses
    self.try(:level).try(:courses)
  end

  def type_name
    TYPES[self.type]
  end

  def with_no_games?
    self.games.blank?
  end

  def clone_with_associations
    new_trivia = self.dup
    new_trivia.course = self.course
    new_trivia.questions << self.questions.map do |old_q|
     new_q = old_q.dup
     new_q.image = old_q.image
     new_q
    end
    new_trivia.save!
    new_trivia
  end

end
