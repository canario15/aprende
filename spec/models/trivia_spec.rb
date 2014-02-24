require 'spec_helper'

describe Trivia do

  describe "attributes" do
    it { should respond_to(:title) }
    it { should respond_to(:tag) }
    it { should respond_to(:description) }
    it { should respond_to(:course_id) }
    it { should respond_to(:type) }
  end

  describe "relations" do
    it { should respond_to(:course) }
    it { should have_one(:level) }
    it { should have_many(:questions) }
    it { should have_many(:games) }
    it { should respond_to(:teacher) }
  end

  describe '#with_no_games?' do

    before :each do
      @trivia_with_games = Trivia.make!
      @game = Game.make!(trivia: @trivia_with_games)
      @trivia = Trivia.make!
    end

    it 'returns false when the trivia has games' do
      expect(@trivia_with_games.with_no_games?).to eq(false)
    end

    it 'returns true when the trivia has games' do
      expect(@trivia.with_no_games?).to eq(true)
    end
  end

  describe "create Trivia" do

    it 'with valid attributes' do
      expect{Trivia.make!}.to change{Trivia.count}.by(1)
    end

    it 'with title and tag and course' do
      expect{Trivia.make!(description: nil)}.to change{Trivia.count}.by(1)
    end

    it 'with course and without title' do
      expect{Trivia.make!(title: nil)}.to raise_error
    end

    it 'without course and with title' do
      expect{Trivia.make!(course: nil)}.to raise_error
    end

    it 'without type' do
      expect{Trivia.make!(type: nil)}.to raise_error
    end
  end

  describe "validate Trivia:" do

    it "must have a title" do
      expect(subject).to validate_presence_of :title
    end

    it "must have a course" do
      expect(subject).to validate_presence_of :course
    end
  end

  describe 'trivium scope' do
    before :each do
      @t1 = Trivia.make!(:filled)
      @t2 = Trivia.make!(:filled)
      @t3 = Trivia.make!(:filled)
      Trivia.make!
      Trivia.make!
      @t6 = Trivia.make!(:filled)
      @t7 = Trivia.make!(:filled)
    end

    it'with questions'do
      expect(Trivia.with_questions).to include(@t1,@t2,@t3,@t6,@t7)
    end

    it'with questions limit 3'do
      expect(Trivia.with_questions_and_limit).to include(@t1,@t2,@t3)
    end

    it'search with questions all'do
      expect(Trivia.search_with_questions("trivia")).to include(@t1,@t2,@t3,@t6,@t7)
    end

    it'search with questions two'do
      @t2.update(title: "Test")
      @t6.update(title: "Test")
      expect(Trivia.search_with_questions("Test")).to include(@t2,@t6)
    end
  end

  describe "clone Trivia" do
    it 'without associations' do
      @trivia = Trivia.make!
      expect{@trivia.clone_with_associations}.to change{Trivia.count}.by(1)
    end

    it 'with course' do
      @trivia = Trivia.make!(:filled)
      expect(@trivia.clone_with_associations.course).to eq(@trivia.course)
    end

    it 'with questions' do
      @trivia = Trivia.make!(:filled)
      expect(@trivia.clone_with_associations.questions.last.description).to eq(@trivia.questions.last.description)
    end

    it 'with questions with image' do
      @trivia = Trivia.make!(:filled_image)
      expect(@trivia.clone_with_associations.questions.first.image.file?).to eq(true)
    end

    it 'with questions without image' do
      @trivia = Trivia.make!(:filled)
      expect(@trivia.clone_with_associations.questions.first.image.file?).to eq(false)
    end

  end
end
