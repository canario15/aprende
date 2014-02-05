require 'spec_helper'

describe HomeController do
  render_views
  describe "GET 'index' with user" do
    before :each do
      @user = User.make!
      sign_in @user
    end
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it 'render the index template' do
      get 'index'
      expect(response.body).to match("Home")
    end
  end
  
  describe "GET 'index' without user" do
    it "returns http success" do
      get 'index'
      expect(response).not_to be_success
    end
  end

end
