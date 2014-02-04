require 'spec_helper'

describe UsersController do

  describe "GET 'index' " do
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
      expect(response).to render_template(:index)
    end

    it'load all users in @users' do
      b_user = User.make!(first_name: 'b_user')
      a_user = User.make!(first_name: 'a_user')
      get 'index'
      expect(assigns(:users)).to eq([@user,a_user,b_user])
    end
  end  
end
