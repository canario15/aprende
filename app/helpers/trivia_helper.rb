module TriviaHelper

	def type_multiple_choice?(type)
		Trivia::TYPES.include?(type) && type == Trivia::TYPE_MULTIPLE_CHOICE
	end

  def create_or_continue_game(trivia)
    game_started = trivia.game_started_by_user(current_user)
    if game_started
      (link_to "Reiniciar", game_create_path(trivia.id),method: :post, class:"btn btn-blackboard") +
      (link_to "Continuar", update_trivium_games_path(trivia,game_started) , method: :patch, class:"btn btn-blackboard")
    else
      link_to "Comenzar", game_create_path(trivia.id),method: :post, class:"btn btn-blackboard"
    end
  end
end
