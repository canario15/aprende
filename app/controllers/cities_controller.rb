class CitiesController < ApplicationController

  def state_cities
    @cities = State.find(params[:state_id]).cities.order_name
    respond_to { |format| format.js }
  end

end
