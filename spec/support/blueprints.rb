require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
  first_name { "First Name {sn}" }
  last_name { "Last Name {sn}" }
  email { "#{sn}@vairix.com" }
  password { "1234567890" }
  password_confirmation { "1234567890" }
  first_name { "Nombre #{sn}" }
  last_name { "Apellido #{sn}" }
  group { "Grupo #{sn}" }
  school { "Escuela #{sn}" }
  city { City.make }
  institute { Institute.make }
  confirmed_at { Time.now.utc }
  company { Company.make }
end

Question.blueprint do
  description { "¿Cual es la capital de Uruguay?" }
  dificulty { 1 }
  answer { "Montevideo" }
end

Question.blueprint(:one) do
  description { "¿Cual es la capital de Uruguay?" }
  dificulty { 1 }
  answer { "Montevideo" }
end

Question.blueprint(:two) do
  description { "¿Cual es el principal Rio que cruza a Uruguay por la mitad?" }
  dificulty { 1 }
  answer { "Rio Negro" }
end

Question.blueprint(:three) do
  description { "¿Cual la estrella mas brillante en el cielo?" }
  dificulty { 2 }
  answer { "Sirio" }
end

Question.blueprint(:four) do
  description { "¿Cual es la calle mas larga en la ciudad de Montevideo?" }
  dificulty { 3 }
  answer { "Rivera" }
end

Question.blueprint(:five) do
  description { "¿Que dia arranca el Verano en Uruguay?" }
  dificulty { 3 }
  answer { "21 de diciembre" }
end

Question.blueprint(:filled) do
  description { "¿Que dia arranca el Verano en Uruguay?" }
  dificulty { 3 }
  answer { "21 de diciembre" }
  incorrect_answer_one { "21 de enero" }
  incorrect_answer_two { "21 de febrero" }
  incorrect_answer_three { "21 de marzo" }
  incorrect_answer_four { "21 de abril" }
end

Question.blueprint(:filled_image) do
  description { "¿Que dia arranca el Verano en Uruguay?" }
  dificulty { 3 }
  answer { "21 de diciembre" }
  incorrect_answer_one { "21 de enero" }
  incorrect_answer_two { "21 de febrero" }
  incorrect_answer_three { "21 de marzo" }
  incorrect_answer_four { "21 de abril" }
  image {File.new(File.join(Rails.root, 'spec', 'fixtures', 'Test.jpeg'))}
end

Course.blueprint do
  title {"Literatura"}
  company { Company.make! }
end

Trivia.blueprint do
  title {"Trivia de Paises"}
  type {1}
  course
  teacher
  company { Company.make! }
end

Trivia.blueprint(:filled) do
  title { "Trivia Title #{sn}" }
  tag { "Trivia Tag #{sn}" }
  type { 1 }
  course { Course.make!  }
  teacher { Teacher.make! }
  questions (1)
  company  { Company.make! }
end

Trivia.blueprint(:filled_image) do
  title { "Trivia Title #{sn}" }
  tag { "Trivia Tag #{sn}" }
  type { 1 }
  course { Course.make!  }
  teacher { Teacher.make! }
  questions {[Question.make!(:filled_image)]}
  company  { Company.make! }
end

Question.blueprint do
  description {"Caul es el color de vairix"}
  answer {"Verde"}
  dificulty {1}
  incorrect_answer_one {"Azul"}
  incorrect_answer_two {"Negro"}
  incorrect_answer_three {"Rojo"}
  incorrect_answer_four {"Celeset"}
  trivia
end

Teacher.blueprint do
  first_name { "#First Name {sn}" }
  last_name { "#Last Name {sn}" }
  email { "#{sn}@vairix.com" }
  city { City.make }
  password { "1234567890" }
  password_confirmation { "1234567890" }
  inactive {false}
  confirmed_at { Time.now.utc }
  company { Company.make!}
end

State.blueprint do
  name {"Colonia"}
end

City.blueprint do
  name {"Carmelo"}
  state {State.make!}
end

Game.blueprint do
  trivia
end

Answer.blueprint do
  was_correct {true}
  question
  game
end

Institute.blueprint do
  name {"Liceo N° 1"}
  city
  company
end

Admin.blueprint do
  email { "#{sn}@vairix.com" }
  password { "1234567890" }
  password_confirmation { "1234567890" }
  company 
end

Notification.blueprint do
end

Pdf.blueprint do
  document {File.new(File.join(Rails.root, 'spec', 'fixtures', 'Test.pdf'))}
end

Written.blueprint do
  document {"Conteido de texto"}
end

Content.blueprint do
end

Company.blueprint do
  name  { "VAIRIX" }
  email { "info@vairix.com"}
end