require 'spec_helper'

describe Users::OmniauthCallbacksController do

  describe "GET #facebook" do
    before do 
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end 

    it 'authenticate and identify user if user is known' do
      expect(get :facebook).to be_redirect
    end 

    it "successfully create a user" do
      expect { get :facebook }.to change{ User.count }.by(1)
    end
  end
end