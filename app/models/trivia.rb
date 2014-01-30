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

  TYPES = {1 => I18n.t('trivia.type.multiple_choice'), 2 => I18n.t('trivia.type.free')}

  TYPE_MULTIPLE_CHOICE = TYPES.keys.first

  def level_courses
    self.try(:level).try(:courses)
  end
end
