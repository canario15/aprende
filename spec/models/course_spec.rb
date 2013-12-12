require 'spec_helper'

describe Course do

  describe "relations" do
    it { should respond_to(:level) }
  end

  describe "create Course" do

    it 'with title and level' do
      expect{Course.make!}.to change{Course.count}.by(1)
    end

    it 'with title and without level' do
      expect{Course.make!(level: nil)}.to raise_error
    end

    it 'with level and without title' do
      expect{Course.make!(title: nil)}.to raise_error
    end
  end

  describe "validate Course:" do
    it "must have a title" do
      expect(subject).to validate_presence_of :title
    end

    it "must have a level" do
      expect(subject).to validate_presence_of :level
    end
  end

end