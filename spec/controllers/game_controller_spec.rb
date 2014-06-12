require 'spec_helper'

describe GameController do

  describe "GET 'index', teacher without game" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
    end

    it "returns http success" do
      get :index_teacher
      expect(response).to be_success
    end
  end

  describe "GET 'index', user without games" do
    before :each do
      @user = User.make!
      sign_in @user
    end

    it "returns http success" do
      get :index_user
      expect(response).to be_success
    end
  end

  describe "GET 'index', teacher with trivia" do
    render_views
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
      @game.finish
    end

    it "returns http success" do
      get :index_teacher
      expect(response).to be_success
    end

    it "render have pdf link" do
      get :index_teacher
      expect(response.body).to match(game_results_teacher_path(@game, format: :pdf))
    end
  end

  describe "GET 'index', user with trivia" do
    render_views
    before :each do
      @teacher = Teacher.make!
      @user = User.make!
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
      @game.finish
      @user.games << @game
      sign_in @user
    end

    it "returns http success" do
      get :index_user
      expect(response).to be_success
    end

    it "render have pdf link" do
      get :index_user
      expect(response.body).to match(game_results_user_path(@game, format: :pdf))
    end
  end

  describe "GET 'game_results_teacher'" do
    render_views
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
    end

    it "returns http success" do
      get :game_results_teacher, {:id => @game.id}
      expect(response).to be_success
    end

    it "pdf returns http success" do
      get :game_results_teacher, {id: @game.id, format: :pdf}
      expect(response).to be_success
    end

    it "render have pdf link" do
      get :game_results_teacher, {id: @game.id}
      expect(response.body).to match(game_results_teacher_path(@game, format: :pdf))
    end
  end

  describe "GET 'games_played'" do
    render_views
    before :each do
      @teacher = Teacher.make!
      @user = User.make!
      @trivia = Trivia.make!(teacher: @teacher)
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
      Answer.make!(game:@game, question: @question)
      @game.finish
      @user.games << @game
      sign_in @user
    end

    it "returns http success" do
      get :index_user
      expect(response).to be_success
    end

    it "has the trivia with title" do
      get :index_user
      expect(response.body).to match(@user.games.first.trivia.title)
    end

    it "returns http success" do
      get :game_results_user, {:id => @game.id}
      expect(response).to be_success
    end

    it "pdf returns http success" do
      get :game_results_user, {id: @game.id, format: :pdf}
      expect(response).to be_success
    end

    it "render have pdf link" do
      get :game_results_user, {id: @game.id}
      expect(response.body).to match(game_results_user_path(@game, format: :pdf))
    end
  end

  describe "GET 'games_played_not_logged_in'" do
    before :each do
      get :index_user
    end

    it "redirects to user sign in" do
      expect(response).to redirect_to new_user_session_path
    end

    it "shows an error message" do
      expect(flash[:alert]).to eq ("You need to sign in or sign up before continuing.")
    end
  end

  describe "new Game" do
    render_views
    before :each do
      @user = User.make!
      sign_in @user
      @teacher = Teacher.make!
      @trivia = Trivia.make!(teacher: @teacher)
      @question_1 = Question.make!(:one,trivia: @trivia)
      @question_2 = Question.make!(:two,trivia: @trivia)
    end

    it "get 'new' returns http success(code=200)" do
      get 'new', {:trivia_id => @trivia.id}
      expect(response.code).to eq("200")
    end

    it "post create, create to Game in Database" do
      params = {:trivia_id => @trivia.id}
      expect {post('create', params) }.to change{Game.count}.by(1)
    end

    it "post 'create' game status is Started" do
      post 'create', {:trivia_id => @trivia.id}
      game = Game.last
      expect(game.status).to eq(Game::STATUS[:started])
    end

    it "post create, create game and show view eval_answer" do
      params = {:trivia_id => @trivia.id}
      post('create', params)
      expect(response.body).to match /Pregunta/
    end

    it "post create, create game and invoke eval_answer and answer TRUE" do
      params = {:trivia_id => @trivia.id}
      post('create', params)
      params = {:trivia_id => @trivia.id, :question_id => @question_1.id, :select_answer => @question_1.answer}
      post('eval_answer', params)
      expect(response.body).to match /Correcto/
    end

    it "post create, create game and invoke eval_answer and answer FALSE" do
      params = {:trivia_id => @trivia.id}
      post('create', params)
      params = {:trivia_id => @trivia.id, :question_id => @question_1.id, :select_answer => @question_2.answer}
      post('eval_answer', params)
      expect(response.body).to match /Incorrecto/
    end

    it "post create, create game and invoke eval_answer and Finish" do
      params = {:trivia_id => @trivia.id}
      post('create', params)
      params = {:trivia_id => @trivia.id, :question_id => @question_1.id, :select_answer => @question_2.answer}
      post('eval_answer', params)
      params = {:trivia_id => @trivia.id, :question_id => @question_2.id, :select_answer => @question_2.answer}
      post('eval_answer', params)
      game = Game.last
      expect(game.status).to eq(Game::STATUS[:finished])
      expect(response.body).to match /Ya ha respondido todas las preguntas!! Su puntaje fue: #{game.score}/
    end
  end

  describe "update Game" do
    render_views
    before :each do
      @user = User.make!
      sign_in @user
      @teacher = Teacher.make!
      @trivia = Trivia.make!(teacher: @teacher)
      question_1 = Question.make!(:one,trivia: @trivia)
      question_2 = Question.make!(:two,trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
    end

    it "patch update render" do
      params = {:trivia_id => @trivia.id, id: @game.id}
      patch :update, params
      expect(response.body).to match /Puntaje/
    end

    it "patch update success" do
      params = {:trivia_id => @trivia.id, id: @game.id}
      patch :update, params
      expect(response).to be_success
    end

  end

  describe "sign in confrim" do
    before :each do
      @teacher = Teacher.make!
    end

    context "with confirmation" do
      render_views
      before :each do
        sign_in @teacher
      end

      it "return http success" do
        get :index_teacher
        expect(response).to be_success
      end

      it "return render view" do
        get :index_teacher
        expect(response.body).to match("trivias")
      end
    end

    context "without confirmation" do
      before :each do
        @teacher.update(confirmed_at: nil)
        sign_in @teacher
      end

      it "return http redirect" do
        get :index_teacher
        expect(response).to be_redirect
      end

      it "return http flash message" do
        get :index_teacher
        expect(flash[:alert]).to match("You have to confirm your account before continuing.")
      end

      it "return location" do
        get :index_teacher
        expect(response.location).to match(teacher_session_path)
      end
    end
  end
end