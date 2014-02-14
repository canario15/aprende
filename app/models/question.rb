class Question < ActiveRecord::Base
  belongs_to :trivia
  has_attached_file :image, :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50"},:default_url => "/assets/:style/missing.jpg"
  validates :description,:answer, presence: true
  validates :incorrect_answer_one, presence: true , if: ->{ trivia.type == Trivia::TYPE_MULTIPLE_CHOICE}
  DIFICULTY = [1,2,3,4,5]
end