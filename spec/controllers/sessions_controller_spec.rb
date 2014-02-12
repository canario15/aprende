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
end