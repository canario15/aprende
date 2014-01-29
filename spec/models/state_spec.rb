require 'spec_helper'

describe State do

  describe "attributes" do
    it { should respond_to(:name) }
  end

  describe "validates" do

    it 'validate presence' do
      expect(subject).to validate_presence_of :name
    end

  end


  describe "create State" do

    it 'valid attributes' do
      expect{State.make!}.to change{State.count}.by(1)
    end

    it 'invalid attributes' do
      expect{State.make!(name: nil)}.to raise_error
    end

  end
end