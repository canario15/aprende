require 'spec_helper'

describe Company do
  describe "attributes" do
    it { should respond_to(:email) }
    it { should respond_to(:limit_of_teachers) }
    it { should respond_to(:limit_of_users) }
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
