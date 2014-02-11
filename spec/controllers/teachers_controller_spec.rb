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

  describe "GET 'edit'" do
    before :each do
      @teacher = Teacher.make!
    end

    it "returns http success(code=200)" do
      get 'edit', {:id => @teacher.id}
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'update'" do
    before :each do
      @teacher = Teacher.make!(:filled)
      sign_in @teacher
    end

    it "redirects to the index of teachers" do
      params = {:id => @teacher.id, :teacher => {:phone => "2222" }}
      patch 'update', params
      expect(response).to redirect_to(teachers_path)
    end

    it "the teacher data, and assigns its value to the flash notice" do
      params = {:id => @teacher.id, :teacher => {:first_name => 'albert'}}
      patch 'update', params
      name = Teacher.find @teacher.id
      expect(flash[:notice]).to eq ("Datos de #{name} actualizados.")
    end
  end
end