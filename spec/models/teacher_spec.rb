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
    it { should have_and_belong_to_many(:institutes)}
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

  describe 'scope' do
    describe 'order by name asc' do
      it 'Creates teachers'do
        b_teacher = Teacher.make!(first_name: 'b_teacher')
        a_teacher = Teacher.make!(first_name: 'a_teacher')
        expect(Teacher.system_teachers).to eq([a_teacher,b_teacher])
      end
    end

    describe "with games week ago" do
      before :each do
        (1..4).each do |index_t|
          teacher = Teacher.make!
          user = User.make!
          user.confirm!
          trivia = Trivia.make!(teacher: teacher)

          (1..4).each do |index_g|
            question = Question.make!(trivia:trivia)
            game = Game.make!(trivia: trivia)
            Answer.make!(game:game, question: question)
            game.finish
            user.games << game
          end
        end
      end

      it "all games in this weeks" do
        teachers = Teacher.with_games_week_ago
        expect(teachers.length).to eq(4)
      end

      it "half of the games in this week" do
        Game.all.each_slice(8).first.each do |g|
          g.update(updated_at: 1.week.ago)
        end
        teachers = Teacher.with_games_week_ago
        expect(teachers.length).to eq(2)
      end

      it "even games in this week" do
        Game.all.each_with_index do |g,index|
          g.update(updated_at: 1.week.ago)  if index.even?
        end
        teachers = Teacher.with_games_week_ago
        expect(teachers.length).to eq(4)
      end

      it "empty games in this week" do
        Game.all.each do |g|
          g.update(updated_at: 1.week.ago)
        end
        teachers = Teacher.with_games_week_ago
        expect(teachers.length).to eq(0)
      end
    end
  end

  describe 'games' do
    it' finished'do
      @teacher = Teacher.make!
      expect{
        @user = User.make!
        @trivia = Trivia.make!(teacher: @teacher)
        @question = Question.make!(trivia: @trivia)
        @game = Game.make!(user:@user,trivia: @trivia)
        Answer.make!(game:@game, question: @question)
        @game.finish
       }.to change {@teacher.games_finished.count}.by(1)
    end

    it'not finished'do
      @teacher = Teacher.make!
      expect{
        @user = User.make!
        @trivia = Trivia.make!(teacher: @teacher)
        @question = Question.make!(trivia: @trivia)
        @game = Game.make!(user:@user,trivia: @trivia)
        Answer.make!(game:@game, question: @question)
       }.to change {@teacher.games_finished.count}.by(0)
    end
  end

  describe "Mailers at Create" do
    before(:each) do
      @teacher = Teacher.make!
    end

    it 'to' do
      expect(ActionMailer::Base.deliveries.last.to.first ).to eq(@teacher.email)
    end

    it 'subject' do
      expect(ActionMailer::Base.deliveries.last.subject ).to match("Confirmation instructions")
    end

    it 'body' do
      expect(ActionMailer::Base.deliveries.last.body ).to match("confirmation_token")
    end
  end

  describe "send email with games statistics" do
    before :each do
      @teacher = Teacher.make!
      user = User.make!
      user.confirm!
      trivia = Trivia.make!(teacher: @teacher)
      question = Question.make!(trivia:trivia)
      game = Game.make!(trivia: trivia)
      Answer.make!(game:game, question: question)
      game.finish
      user.games << game
      Teacher.send_email
    end


    it 'to' do
      expect(ActionMailer::Base.deliveries.last.to.first ).to eq(@teacher.email)
    end

    it 'subject' do
      expect(ActionMailer::Base.deliveries.last.subject ).to match("Estadística de los juegos")
    end

    it 'body' do
      expect(ActionMailer::Base.deliveries.last.body ).to match("Estadística de los juegos")
    end
  end
end
