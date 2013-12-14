require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    before :each do
      @user = User.make!
      sign_in @user
    end
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
