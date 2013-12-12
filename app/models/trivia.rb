class Trivia < ActiveRecord::Base
  belongs_to :course

  validates :title, :presence => true
  validates :course, :presence => true
end
