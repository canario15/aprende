module TriviaHelper

	def type_multiple_choice?(type)
		Trivia::TYPES.include?(type) && type == Trivia::TYPE_MULTIPLE_CHOICE
	end

end
