class Institute < ActiveRecord::Base
  belongs_to :city
  has_one :state,  :through => :city
  validates :name, :presence => true

  def to_s
    self.name
  end

end
