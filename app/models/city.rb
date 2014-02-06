class City < ActiveRecord::Base

  belongs_to :state
  validates :name, :presence => true
  validates :state_id, :presence => true
  has_many :institutes
  has_many :teachers
  scope :order_name, -> { order('name') }

  def to_s
  	self.name
  end
end
