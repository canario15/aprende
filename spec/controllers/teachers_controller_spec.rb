require 'spec_helper'

describe TeachersController do

  describe "GET 'index' logged in as Admin" do
    before :each do
      @teacher = Teacher.make!
      @admin = Admin.make!
      sign_in @admin
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

  describe "GET 'index with teachers' cities' logged in as Admin" do
    render_views
    before :each do
      @teacher = Teacher.make!(:filled)
      @admin = Admin.make!
      sign_in @admin
    end

    it "shows the teachers' cities'" do
      get 'index'
      expect(response.body).to match /Listado de maestros/
      expect(response.body).to match /Ciudad/
      expect(response.body).to match (@teacher.city.name)
    end
  end

  describe "GET 'index' logged in as a Teacher" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
      get 'index'
    end

    it "redirects to the Admin login" do
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "flash alert has the value assigned" do
      expect(flash[:alert]).to eq ("You need to sign in or sign up before continuing.")
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
      expect(response).to redirect_to(teacher_path)
    end

    it "the teacher data, and assigns its value to the flash notice" do
      params = {:id => @teacher.id, :teacher => {:first_name => 'albert'}}
      patch 'update', params
      name = Teacher.find @teacher.id
      expect(flash[:notice]).to eq ("Datos de #{name} actualizados.")
    end
  end

  describe "POST 'update with institutes ids'" do
    before :each do
      @teacher = Teacher.make!(:filled)
      @institute1 = Institute.make!
      @institute2 = Institute.make!
      sign_in @teacher
    end

    it "updates the teacher's with institutes and redirect to the teacher path" do
      params = {:id => @teacher.id, :teacher => {:phone => "2222", institute_ids:[ @institute1.id, @institute2.id]}}
      patch 'update', params
      expect(@teacher.institutes.count).to be(2)
      expect(response).to redirect_to(teacher_path)
    end

    it "doesn't update the teacher with invalid literals for the institutes ids" do
      params = {:id => @teacher.id, :teacher => {:phone => "2222", institute_ids:[ 'a', 'b']}}
      expect{patch 'update', params}.to raise_error
    end
  end

  describe "change teacher status" do

    it "inactivate teacher" do
      @teacher = Teacher.make!
      xhr :post, :inactivate_or_activate, {teacher_id: @teacher.id}
      t = Teacher.find @teacher.id
      expect(t.inactive).to be(true)

    end

    it "activate teacher" do
      @teacher = Teacher.make!(inactive: true)
      xhr :post, :inactivate_or_activate, {teacher_id: @teacher.id}
      teacher = Teacher.find @teacher.id
      expect(teacher.inactive).to be(false)
    end
  end

   describe "GET 'sign_in'" do
    before :each do
      @teacher = Teacher.make!
      @teacher.confirm!
      sign_in @teacher
    end

    it "first login" do
      @teacher.sign_in_count = 1
      expect(controller.after_sign_in_path_for(@teacher)).to eq(edit_teacher_path(@teacher))
    end

    it "not first login" do
      @teacher.sign_in_count = 2
      expect(controller.after_sign_in_path_for(@teacher)).to eq(games_teacher_path)
    end
  end
end