class Level < ActiveRecord::Base
  has_many :courses

  validates :title, :presence => true

  def to_s
    title
  end
end