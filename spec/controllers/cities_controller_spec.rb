require 'spec_helper'

describe CitiesController do

  describe "GET 'state_cities'" do
    before :each do
      @state = State.make!
    end

    it "returns http success " do
      get :state_cities, {state_id: @state.id, format: :js}
      expect(response).to be_success
    end
  end
end
