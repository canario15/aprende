require 'spec_helper'

describe Company do
  describe "attributes" do
    it { should respond_to(:email) }
    it { should respond_to(:name) }
  end

  describe "relations" do
    it { should respond_to(:admin) }
    it { should have_many(:teachers)}
  end

  describe 'Company Create' do
    it 'Creates a Company'do
      expect{ Company.make! }.to change {Company.count}.by(1)
    end
  end
end