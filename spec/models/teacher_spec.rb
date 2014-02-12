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
    it { should respond_to(:avatar) }
  end

  describe "relations" do
    it { should have_many(:trivium)}
    it { should belong_to(:city)}
  end

  describe "validate the presence of attributes in Teacher:" do
    it { should validate_presence_of :email}
    it { should validate_presence_of :password}
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

  describe 'Teacher scope order by name asc' do
    it'Creates teachers'do
      b_teacher = Teacher.make!(first_name: 'b_teacher')
      a_teacher = Teacher.make!(first_name: 'a_teacher')
      expect(Teacher.system_teachers).to eq([a_teacher,b_teacher])
    end
  end

 describe "Mailers at Create" do
    before(:each) do
      @teacher = Teacher.make!
    end

    it 'to'do
      expect(ActionMailer::Base.deliveries.last.to.first ).to eq(@teacher.email)
    end

    it 'subject 'do
      expect(ActionMailer::Base.deliveries.last.subject ).to match("Confirmation instructions")
    end

    it 'body'do
      expect(ActionMailer::Base.deliveries.last.body ).to match("confirmation_token")
    end

  end
end
