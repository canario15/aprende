class Course < ActiveRecord::Base
  belongs_to :level

  validates :title, :presence => true
  validates :level, :presence => true
end
