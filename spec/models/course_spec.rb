require 'spec_helper'

describe Course do

  describe "relations" do
    it { should respond_to(:trivium) }
  end

  describe "attributes" do
    it { should respond_to(:title) }
    it { should respond_to(:image) }
  end

  describe "create Course" do

    it 'without title' do
      expect{Course.make!(title: nil)}.to raise_error
    end
  end

  describe "validate Course:" do
    it "must have a title" do
      expect(subject).to validate_presence_of :title
    end

  end

end
