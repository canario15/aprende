require 'spec_helper'

describe TriviumController do
	before :all do
    @course = Course.make!
  end

  describe "GET 'index'" do
    it "returns http success(code=200)" do
      get 'index'
      expect(response.code).to eq("200")
    end
  end

  describe "GET 'new'" do
    it "returns http success(code=200)" do
      get 'new'
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'create'" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
    end

    it "create a new trivia" do
      get 'new'
      expect(response.code).to eq("200")
    end

    it "returns http success" do
      params = {:trivia => {:title => "New trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic", :type => 1}}
      expect {post('create', params) }.to change{Trivia.count}.by(1)
    end

    it "invalid trivia without teacher" do
      sign_out @teacher
      params = {:trivia => {:title => "New trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic", :type => 1}}
      expect {post('create', params) }.to change{Trivia.count}.by(0)
    end

  end

  describe "GET 'edit'" do
    before :each do
      @trivia = Trivia.make!
    end

    it "returns http success(code=200)" do
      get 'edit', {:id => @trivia.id}
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'update'" do
    before :each do
      @trivia = Trivia.make!
    end

    it "returns http success" do
      params = {:id=> @trivia.id, :trivia => {:title => "update trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic"}}
      post 'update', params
      expect(response).to redirect_to(new_question_trivia_url(@trivia.id))
    end
  end

  describe "GET 'new_question'" do
  	before :each do
      @trivia = Trivia.make!
      @question = Question.make!
    end

  	it "returns http success(code=200) without question" do
      get 'new_question', {:id => @trivia.id}
      expect(response.code).to eq("200")
    end

    it "returns http success with question" do
      get 'new_question', {:id => @question.trivia.id}
      expect(response.code).to eq("200")
    end
  end

	describe "POST 'create_question'" do
  	before :each do
      @trivia = Trivia.make!
    end

    it "created a new question to trivia " do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect {post('create_question', params) }.to change{Question.count}.by(1)
    end

    it "returns http success, return 'new_question_trivia_url'" do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'create_question', params
      expect(response).to redirect_to(new_question_trivia_url(@trivia.id))
    end

    it "returns http success, return 'trivium_url' " do
      params = {:id => @trivia.id, :finish => "true", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'create_question', params
      expect(response).to redirect_to(trivium_url)
    end
  end

  describe "GET 'edit_question'" do
  	before :each do
      @question = Question.make!
    end

  	it "returns http success(code= 200)" do
      get 'edit_question', {:id => @question.trivia.id, :question_id => @question.id}
      expect(response.code).to eq("200")
    end
  end

  describe "GET 'update_question'" do
  	before :each do
      @question = Question.make!
    end

  	it "returns http success, return 'new_question_trivia_url' " do
      params = {:id => @question.trivia.id, :question_id => @question.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'update_question', params
      expect(response).to redirect_to(new_question_trivia_url)
    end

   	it "returns http success, return 'trivium_url' " do
      params = {:id => @question.trivia.id, :question_id => @question.id, :finish => "true", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'update_question', params
      expect(response).to redirect_to(trivium_url)
    end
  end

end