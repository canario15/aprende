class Trivia < ActiveRecord::Base
  belongs_to :course

  has_one :level, :through => :course
  has_many :questions

  validates :title, :presence => true
  validates :course, :presence => true

  def level_courses
  	self.try(:level).try(:courses)
  end
end
