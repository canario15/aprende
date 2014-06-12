class Company < ActiveRecord::Base
  has_one :admin
  has_many :teachers
end
