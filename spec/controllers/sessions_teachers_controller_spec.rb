require 'spec_helper'

describe Teachers::SessionsController do
  describe "devise overriding" do
    before :each do
      @teacher = Teacher.make!
    end

    it 'returns success' do
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      post 'create', { :teacher => {:email=> @teacher.email} }
      expect(response).to be_succes
    end
  end

  describe "create devise overriding" do
    before :each do
      @teacher = Teacher.make!(inactive: true)
    end

    it 'redirects to Teacher login' do
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      post 'create', { :teacher => {:email=> @teacher.email} }
      expect(response.location).to redirect_to(new_teacher_session_path)
    end
  end

  describe "new signed in?" do
    it 'admin sign in redirects to welcome' do
      admin = Admin.make!
      sign_in admin
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      get :new
      expect(response.location).to redirect_to(welcome_index_path)
    end

    it 'user sign in redirects to welcome' do
      user = User.make!
      sign_in user
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      get :new
      expect(response.location).to redirect_to(welcome_index_path)
    end

    it 'teacher sign in redirects to games teacher' do
      teacher = Teacher.make!
      sign_in teacher
      @request.env["devise.mapping"] = Devise.mappings[:teacher]
      get :new
      expect(response.location).to redirect_to(games_teacher_path)
    end

  end

  it "switch" do
    admin = Admin.make!
    teacher = Teacher.make!(admin: admin)
    @request.env["devise.mapping"] = Devise.mappings[:teacher]
    sign_in teacher
    get 'switch'
    expect(response.location).to redirect_to(courses_path)
  end
end