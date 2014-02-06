module StatesHelper

  def all_state
    State.all
  end

  def cities_from_first_state
    state = State.first
    state.cities.order_name
  end
end
