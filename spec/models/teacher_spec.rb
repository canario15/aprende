require 'spec_helper'

describe Teacher do

  describe "attributes" do
    it { should respond_to(:email) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:phone) }
    it { should respond_to(:description) }
  end

  describe 'Teacher Create' do
    it 'Creates a Teacher'do
      expect{ Teacher.make! }.to (change(Teacher, :count).by(1))
    end

    it 'with email nil' do
      expect{Teacher.make!(email: nil)}.to raise_error
    end

    it 'with password nil' do
      expect{Teacher.make!(password: nil)}.to raise_error
    end

  end

  describe "validate the presence of attributes in Teacher:" do
    it "must have an email and password" do
      expect(subject).to validate_presence_of :email
      expect(subject).to validate_presence_of :password
    end
  end

end
