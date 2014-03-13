class TeacherMailer < ActionMailer::Base
  default from: "user.vairix@gmail.com"

  def trivia_statistics(teacher)
    @games = teacher.games.week_ago_group_by_trivia
    mail to:  teacher.email, subject: "Estadística de los juegos"
  end
end
