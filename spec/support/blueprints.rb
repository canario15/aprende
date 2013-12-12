require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
	email { "#{sn}@vairix.com" }
	password { "1234567890" }
	password_confirmation { "1234567890" }
	first_name { "Nombre #{sn}" }
	last_name { "Apellido #{sn}" }
	group { "Grupo #{sn}" }
	school { "Escuela #{sn}" }
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

Level.blueprint do
  title {"Primero"}
end

Course.blueprint do
  title {"Literatura"}
  level
end

