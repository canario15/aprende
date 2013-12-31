class Course < ActiveRecord::Base
  belongs_to :level

  validates :title, :presence => true
  validates :level, :presence => true

  def to_s
  	level.to_s + " - " + title
  end
end
