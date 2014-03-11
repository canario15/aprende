class TeacherMailer < ActionMailer::Base
  default from: "user.vairix@gmail.com"

  def trivia_statistics(teacher)
    @games = teacher.games.week_ago_group_by_trivia
    @games_count = @games.count
    @games_avg = @games.average(:score)
    @answers_corrects_count= @games.answers_was_correct.count
    @answers_count= @games.joins_answers.count
    mail to:  teacher.email, subject: "Estadística de los juegos"
  end
end
