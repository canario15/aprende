class Course < ActiveRecord::Base
  belongs_to :level
  has_attached_file :image, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50"}, :default_url => "/assets/:style/missing.jpg"

  validates :title, :presence => true
  validates :level, :presence => true

  def to_s
    level.to_s + " - " + title
  end
end
