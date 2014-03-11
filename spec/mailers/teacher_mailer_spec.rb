require "spec_helper"

describe TeacherMailer do
  describe "trivia_statistics" do
    before :each do
      @teacher = Teacher.make!
      user = User.make!
      user.confirm!
      trivia = Trivia.make!(teacher: @teacher)
      question = Question.make!(trivia: trivia)
      game = Game.make!(trivia: trivia)
      Answer.make!(game:game, question: question)
      game.finish
      user.games << game
    end

    let(:mail) { TeacherMailer.trivia_statistics(@teacher) }

    it "renders the headers" do
      expect(mail.subject).to eq("Estadística de los juegos")
      expect(mail.to).to eq([@teacher.email])
      expect(mail.from).to eq(["user.vairix@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Estadística de los juegos")
      expect(mail.body.encoded).to match("Cantidad de Juegos")
      expect(mail.body.encoded).to match("Promedio de Puntos")
      expect(mail.body.encoded).to match("Promedio de Preguntas Correctas")
    end
  end

end
