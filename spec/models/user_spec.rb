require 'spec_helper'

describe User do

  describe "attributes" do
    it { should respond_to(:email) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:group) }
    it { should respond_to(:school) }
  end
  
  describe "validate the presence of attributes in User:" do
    it { should validate_presence_of :email}
    it { should validate_presence_of :password}
 end

  describe 'User Create' do
    it 'Creates a User'do
      expect{ User.make! }.to change {User.count}.by(1)
    end

    it 'with email nil' do
      expect{User.make!(email: nil)}.to raise_error
    end

    it 'with password nil' do
      expect{User.make!(password: nil)}.to raise_error
    end

  end

describe 'User scope order by name asc' do
    it'Creates users'do
      b_user = User.make!(first_name: 'b_user')
      a_user = User.make!(first_name: 'a_user')
      expect(User.system_users).to eq([a_user,b_user])
    end
  end

end
