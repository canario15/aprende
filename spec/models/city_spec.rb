require 'spec_helper'

describe City do

  describe "attributes" do
    it { should respond_to(:name) }
  end

  describe "relations" do
    it { should respond_to(:state)}
  end

  describe "validates" do

    it 'validate presence' do
      expect(subject).to validate_presence_of :name
      expect(subject).to validate_presence_of :state_id
    end

  end

  describe "create City" do

    it 'valid attributes' do
      expect{City.make!}.to change{City.count}.by(1)
    end

    it 'invalid attributes: name is nil' do
      expect{City.make!(name: nil)}.to raise_error
    end

    it 'invalid attributes: state is nil' do
      expect{City.make!(state: nil)}.to raise_error
    end

  end
end
