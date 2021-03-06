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
      expect(response.body).to match("Inicio")
    end

    describe "Search with " do
      before :each do
        @trivia0 = Trivia.make!(:filled)
        @trivia1 = Trivia.make!(:filled)
        @trivia2 = Trivia.make!(:filled)
        @trivia3 = Trivia.make!(:filled)
        @params = {search: { q: "Test" }}
      end

      it 'trivia title' do
        @trivia0.update(title: "Title Test 0")
        @trivia3.update(title: "Title Test 3")
        get :index, @params
        expect(assigns[:trivium]).to eq([@trivia0,@trivia3])
      end

      it 'trivia tag' do
        @trivia2.update(tag: "Tag Test 2")
        @trivia3.update(tag: "Tag Test 3")
        get :index, @params
        expect(assigns[:trivium]).to eq([@trivia2,@trivia3])
      end

      it 'trivia teacher city' do
        @trivia0.teacher.city.update(name: "City Test 0")
        @trivia1.teacher.city.update(name: "City Test 1")
        get :index, @params
        expect(assigns[:trivium]).to eq([@trivia0,@trivia1])
      end

      it 'trivia teacher first name' do
        @trivia1.teacher.update(first_name: "First Name Test 1")
        @trivia2.teacher.update(first_name: "First Name Test 2")
        @trivia3.teacher.update(first_name: "First Name Test 3")
        get :index, @params
        expect(assigns[:trivium]).to eq([@trivia1,@trivia2,@trivia3])
      end

      it 'trivia teacher last name' do
        @trivia0.teacher.update(last_name: "Last Name Test 0")
        @trivia1.teacher.update(last_name: "Last Name Test 1")
        @trivia2.teacher.update(last_name: "Last Name Test 2")
        get :index, @params
        expect(assigns[:trivium]).to eq([@trivia0,@trivia1,@trivia2])
      end

      it 'trivia teacher empty params' do
        get :index
        expect(assigns[:trivium]).to eq([@trivia0,@trivia1,@trivia2,@trivia3])
      end
    end
  end

  describe "GET 'index' without user" do
    it "returns http success" do
      get 'index'
      expect(response).not_to be_success
    end
  end

  describe "Sign in confrim" do

    before :each do
      @user = User.make!
    end

    context "with confirmation" do
      render_views
      before :each do
        sign_in @user
      end

      it "return http success" do
        get :index
        expect(response).to be_success
      end

      it "return render view" do
        get :index
        expect(response.body).to match(@user.email)
      end
    end

    context "without confirmation" do
      before :each do
        @user.update(confirmed_at: nil)
        sign_in @user
      end

      it "return http redirect" do
        get :index
        expect(response).to be_redirect
      end

      it "return http flash message" do
        get :index
        expect(flash[:alert]).to match("You have to confirm your account before continuing.")
      end

      it "return location" do
        get :index
        expect(response.location).to match(user_session_path)
      end
    end
  end

end
