require 'spec_helper'

describe TriviumController do
	before :all do
    @course = Course.make!
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    it "create a new trivia" do
      get 'create', {:trivia => {:tilte => "New trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic"}}
      change{Trivia.count}.by(1)
    end

    it "returns http success" do
      post 'create', {:trivia => {:tilte => "New trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic"}}
      expect(response) == 1
    end
  end

  describe "GET 'edit'" do
    before :each do
      @trivia = Trivia.make!
    end

    it "returns http success" do
      get 'edit', {:id => @trivia.id}
      expect(response).to be_success
    end
  end

  describe "POST 'update'" do
    before :each do
      @trivia = Trivia.make!
    end

    it "returns http success" do
      post 'update', {:id=> @trivia.id, :trivia => {:tilte => "update trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic"}}
      expect(response) == 1
    end
  end

  describe "GET 'new_question'" do
  	before :each do
      @trivia = Trivia.make!
      @question = Question.make!
    end

  	it "returns http success without question" do
      get 'new_question', {:id => @trivia.id}
      expect(response).to be_success
    end

    it "returns http success with question" do
      get 'new_question', {:id => @question.trivia.id}
      expect(response).to be_success
    end
  end

	describe "POST 'create_question'" do
  	before :each do
      @trivia = Trivia.make!
    end

    it "returns http success, return 'new_question_trivia_url' " do
      post 'create_question', {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect(response) == 1
    end

    it "returns http success, return 'trivium_url' " do
      post 'create_question', {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect(response) == 1
    end

    it "create a new question" do
      post 'create_question', {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      change{Question.count}.by(1)
    end
  end

  describe "GET 'edit_question'" do
  	before :each do
      @question = Question.make!
    end

  	it "returns http success" do
      get 'edit_question', {:id => @question.trivia.id, :question_id => @question.id}
      expect(response).to be_success
    end
  end

  describe "GET 'update_question'" do
  	before :each do
      @question = Question.make!
    end

  	it "returns http success, return 'new_question_trivia_url' " do
      post 'update_question', {:id => @question.trivia.id, :question_id => @question.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect(response) == 1
    end

   	it "returns http success, return 'trivium_url' " do
      post 'update_question', {:id => @question.trivia.id, :question_id => @question.id, :finish => "true", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect(response) == 1
    end
  end

end