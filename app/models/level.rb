class Level < ActiveRecord::Base
  has_many :courses
  has_many :trivium, through: :courses
  validates :title, :presence => true

  def to_s
    title
  end
end
