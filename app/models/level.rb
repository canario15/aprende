class Level < ActiveRecord::Base
	has_many :courses

	validates :title, :presence => true
end
