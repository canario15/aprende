require 'spec_helper'

describe Admin do
    describe "attributes" do
    it { should respond_to(:email) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:phone) }
  end
  
  describe "validate the presence of attributes" do
    it { should validate_presence_of :email}
    it { should validate_presence_of :password}
 end

  describe 'Admin Create' do
    it 'Creates a Admin'do
      expect{ Admin.make! }.to change {Admin.count}.by(1)
    end

    it 'with email nil' do
      expect{Admin.make!(email: nil)}.to raise_error
    end

    it 'with password nil' do
      expect{Admin.make!(password: nil)}.to raise_error
    end

  end
end
