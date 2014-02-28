class TeacherMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.teacher_mailer.trivia_statistics.subject
  #
  def trivia_statistics(teacher)
    @greeting = "Hi"
    @teacher = teacher
    mail to: @teacher.email, subject: "Estadistica de juegos"
  end

  def trivia_statistics_teacher(teacher)
    debugger
    teachers.each do |t|

      @greeting = "Hi"
      @teacher = t
      mail to:  @teacher.email, subject: "Estadistica de juegos"
    end
  end
end
