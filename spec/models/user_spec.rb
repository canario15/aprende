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
    it { should respond_to(:institute) }
    it { should have_many(:games)}
    it { should respond_to(:city) }
    it { should respond_to(:company) }
  end

  describe "validate the presence of attributes in User:" do
    it { should validate_presence_of :email}
    it { should validate_presence_of :password}
    it { should validate_presence_of :institute}
    it { should validate_presence_of :first_name}
    it { should validate_presence_of :last_name}
    it { should validate_presence_of :company}
 end

  describe 'User Create' do
    it 'Creates a User'do
      expect{ User.make! }.to change {User.count}.by(1)
    end

    it 'raise error when email is nil' do
      expect{User.make!(email: nil)}.to raise_error
    end

    it 'raise error when password is nil' do
      expect{User.make!(password: nil)}.to raise_error
    end

    it 'raise error when company is nil' do
      expect{User.make!(company: nil)}.to raise_error
    end
  end

  describe "User#name" do
    it "concatenates first_name and last_name" do
      user = User.make(first_name: "First", last_name: "Last")  
      expect(user.name).to eq("First Last")
    end
  end

  context 'using scope' do
    describe 'order by name asc' do
      it 'orders correctly with new users'do
        company = Company.make!
        b_user = User.make!(first_name: 'b_user', company: company)
        a_user = User.make!(first_name: 'a_user', company: company)
        expect(User.system_users(company)).to eq([a_user,b_user])
      end

      it 'orders correctly using uppercase and lowercase' do
        company = Company.make!
        b_user_lower = User.make!(first_name: 'b_user', company: company)
        b_user_upper = User.make!(first_name: 'B_user', company: company)
        a_user_upper = User.make!(first_name: 'A_user', company: company)
        a_user_lower = User.make!(first_name: 'a_user', company: company)
        expect(User.system_users(company)).to eq([a_user_upper,a_user_lower,b_user_lower,b_user_upper])
      end
    end
  end

  describe 'games' do
    it 'increases games count when a game was finished'do
      @company = Company.make!
      @user = User.make!(company: @company)
      expect{
        @teacher = Teacher.make!(company: @company)
        @trivia = Trivia.make!(teacher: @teacher)
        @question = Question.make!(trivia: @trivia)
        @game = Game.make!(user:@user, trivia: @trivia)
        
        Answer.make!(game:@game, question: @question)
        @game.finish

      }.to change { @user.games_finished.count }.by(1)
    end

    it 'does not increases finished games count if the game dint finish'do
      @company = Company.make!
      @user = User.make!(company: @company)
      expect{
        @teacher = Teacher.make!
        @trivia = Trivia.make!(teacher: @teacher)
        @question = Question.make!(trivia: @trivia)
        @game = Game.make!(user:@user, trivia: @trivia)

        Answer.make!(game:@game, question: @question)

      }.to change { @user.games_finished.count }.by(0)
    end
  end

  describe "Mailers at Create" do
    before(:each) do
      @user = User.make!(confirmed_at: nil)
    end

    it 'assigns email to destinatary user'do
      expect( ActionMailer::Base.deliveries.last.to.first ).to eq(@user.email)
    end

    it 'assigns correct text to subject'do
      expect( ActionMailer::Base.deliveries.last.subject ).to match("Confirmation instructions")
    end

    it 'assigns confirmation token to email body'do
      expect( ActionMailer::Base.deliveries.last.body ).to match("confirmation_token")
    end
  end

  describe "callbacks" do
    it 'capitalize_first_name at creation' do
      user = User.make!(first_name: 'a user')
      expect(user.first_name).to match("A User")
    end

    it 'capitalize_first_name at update user' do
      user = User.make!
      user.update(first_name: 'a user')
      expect(user.first_name).to match("A User")
    end
  end
end
