require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    it "redirect teacher" do
      @teacher = Teacher.make!
      @teacher.confirm!
      sign_in @teacher
      get :index
      expect(response).to redirect_to(games_teacher_path(@teacher))
    end

    it "redirect user" do
      @user = User.make!
      @user.confirm!
      sign_in @user
      get :index
      expect(response).to redirect_to(home_path)
    end

    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end
end
