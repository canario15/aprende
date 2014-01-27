class Question < ActiveRecord::Base
  belongs_to :trivia
  has_attached_file :image, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50"}, :default_url => "/images/:style/missing.png"
  DIFICULTY = [1,2,3,4,5]
end