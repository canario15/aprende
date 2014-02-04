require 'spec_helper'

describe TeachersController do

  describe "GET 'index' " do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
    end

    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it 'render the index template' do
      get 'index'
      expect(response).to render_template(:index)
    end

    it'load all teachers in @teachers' do
      b_teacher = Teacher.make!(first_name: 'b_teacher')
      a_teacher = Teacher.make!(first_name: 'a_teacher')
      get 'index'
      expect(assigns(:teachers)).to eq([@teacher,a_teacher,b_teacher])
    end
  end
end