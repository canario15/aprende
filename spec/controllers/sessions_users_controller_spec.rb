require 'spec_helper'

describe Users::SessionsController do
  describe "new signed in?" do
    it 'admin sign in redirects to welcome' do
      @admin = Admin.make!
      sign_in @admin
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      expect(response.location).to redirect_to(welcome_index_path)
    end

    it 'teacher sign in redirects to welcome' do
      teacher = Teacher.make!
      sign_in teacher
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      expect(response.location).to redirect_to(welcome_index_path)
    end

    it 'user sign in redirects to home' do
      user = User.make!
      sign_in user
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      expect(response.location).to redirect_to(home_path)
    end

  end
end