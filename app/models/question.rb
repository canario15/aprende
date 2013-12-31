class Question < ActiveRecord::Base
	belongs_to :trivia

	DIFICULTY = [1,2,3,4,5,6,7,8,9,10]

end
