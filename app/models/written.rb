class Written < ActiveRecord::Base
  has_many :contents, as: :containable
  validates :document, presence: true
end