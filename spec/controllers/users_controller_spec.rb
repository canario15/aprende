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
      expect(assigns(:users)).to eq([a_user,b_user,@user])
    end
  end

  describe "GET 'edit'" do
    before :each do
      @user = User.make!
    end

    it "returns http success(code=200)" do
      get 'edit', {:id => @user.id}
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'update'" do
    before :each do
      @user = User.make!
      sign_in @user
    end

    it "redirects to home" do
      params = {:id => @user.id, :user => {:first_name => 'John'}}
      patch 'update', params
      expect(response).to redirect_to(home_path)
    end

    it "the user data, and assigns its value to the flash notice" do
      params = {:id => @user.id, :user => {:first_name => 'albert', :last_name => 'woods'}}
      patch 'update', params
      name = User.find @user.id
      expect(flash[:notice]).to eq ("Datos de #{name} actualizados.")
    end
  end

  describe "GET 'sign_in'" do
    before :each do
      @user = User.make!
      sign_in @user
    end

    it "first login" do
      @user.sign_in_count = 1
      expect(controller.after_sign_in_path_for(@user)).to eq(edit_user_path(@user))
    end

    it "not first login" do
      @user.sign_in_count = 2
      expect(controller.after_sign_in_path_for(@user)).to eq(home_path)
    end
  end

end
