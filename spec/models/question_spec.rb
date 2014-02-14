require 'spec_helper'

describe Question do

  describe "attributes" do
    it { should respond_to(:description) }
    it { should respond_to(:dificulty) }
    it { should respond_to(:answer) }
    it { should respond_to(:trivia_id) }
    it { should respond_to(:image_file_name) }
  end

  describe "relations" do
    it { should belong_to(:trivia)}
  end

  describe 'Question Create' do
    it 'Creates a Question' do
      expect{ Question.make! }.to (change(Question, :count).by(1))
    end

    it 'with description nil' do
      expect{Question.make!(description: nil)}.to raise_error
    end

    it 'with answer nil' do
      expect{Question.make!(answer: nil)}.to raise_error
    end

    it 'with incorrect_answer_1 nil' do
      expect{Question.make!(incorrect_answer_1: nil)}.to raise_error
    end

  end
end
