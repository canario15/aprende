class CitiesController < ApplicationController

  def state_cities
    @cities = State.find(params[:state_id]).cities.order_name
    render :json => { :cities => @cities}
  end

end
