require 'spec_helper'

describe Level do

  describe "relations" do
    it { should have_many(:courses) }
  end

  describe "create Level" do

    it 'with title' do
      expect{Level.make!}.to change{Level.count}.by(1)
    end

    it 'without title' do
      expect{Level.make!(title: nil)}.to raise_error
    end
  end

  describe "validate Level:" do
    it "must have a title" do
      expect(subject).to validate_presence_of :title
    end
  end

end