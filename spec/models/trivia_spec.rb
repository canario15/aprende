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
end
