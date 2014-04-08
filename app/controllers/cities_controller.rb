class CitiesController < ApplicationController

  def state_cities
    @cities = City.none
    @cities = State.find(params[:state_id]).cities.order_name unless params[:state_id].blank?
    respond_to { |format| format.js }
  end

end
