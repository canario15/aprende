class Course < ActiveRecord::Base
  belongs_to :company
  has_many :trivium
  has_attached_file :image, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50"}, :default_url => "/assets/:style/missing.jpg"

  validates :title, :presence => true

  scope :system_courses, ->(company) { where(:company_id => company.id) }

  def to_s
    title
  end
end
