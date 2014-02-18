module StatesHelper

  def all_state
    State.all
  end

  def cities_from_state(state_id)
    (state_id ? State.find(state_id) : State.first).cities.order_name
  end
end
