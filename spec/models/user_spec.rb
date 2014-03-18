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
    it { should respond_to(:avatar) }
  end

  describe "relations" do
    it { should respond_to(:level) }
    it { should respond_to(:institute) }
    it { should have_many(:games)}
    it { should respond_to(:city) }
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

  describe 'scope' do
    describe 'order by name asc' do
      it 'Creates users'do
        b_user = User.make!(first_name: 'b_user')
        a_user = User.make!(first_name: 'a_user')
        expect(User.system_users).to eq([a_user,b_user])
      end

      it'uppercase and lowercase' do
        b_user_lower = User.make!(first_name: 'b_user')
        b_user_upper = User.make!(first_name: 'B_user')
        a_user_upper = User.make!(first_name: 'A_user')
        a_user_lower = User.make!(first_name: 'a_user')
        expect(User.system_users).to eq([a_user_upper,a_user_lower,b_user_lower,b_user_upper])
      end
    end
  end

  describe 'games' do
    it' finished'do
      @user = User.make!
      expect{
        @teacher = Teacher.make!
        @trivia = Trivia.make!(teacher: @teacher)
        @question = Question.make!(trivia: @trivia)
        @game = Game.make!(user:@user,trivia: @trivia)
        Answer.make!(game:@game, question: @question)
        @game.finish
      }.to change {@user.games_finished.count}.by(1)
    end

    it'not finished'do
      @user = User.make!
      expect{
        @teacher = Teacher.make!
        @trivia = Trivia.make!(teacher: @teacher)
        @question = Question.make!(trivia: @trivia)
        @game = Game.make!(user:@user,trivia: @trivia)
        Answer.make!(game:@game, question: @question)
      }.to change {@user.games_finished.count}.by(0)
    end
  end

  describe "Mailers at Create" do
    before(:each) do
      @user = User.make!
    end

    it 'to'do
      expect(ActionMailer::Base.deliveries.last.to.first ).to eq(@user.email)
    end

    it 'subject 'do
      expect(ActionMailer::Base.deliveries.last.subject ).to match("Confirmation instructions")
    end

    it 'body'do
      expect(ActionMailer::Base.deliveries.last.body ).to match("confirmation_token")
    end
  end

  describe "callbacks" do
    it 'capitalize_first_name at create' do
      user = User.make!(first_name: 'a user')
      expect(user.first_name).to match("A User")
    end

    it 'capitalize_first_name at update' do
      user = User.make!
      user.update(first_name: 'a user')
      expect(user.first_name).to match("A User")
    end
  end
end
