# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

level1 = Level.create(title: "Primer año")
level2 = Level.create(title: "Segundo año")
level3 = Level.create(title: "Tercer año")

Course.create(title: "Ciencias sociales",level: level1)
Course.create(title: "Ciencias Matematicas",level: level1)
Course.create(title: "Ingles",level: level2)
Course.create(title: "Geografia",level: level2)
Course.create(title: "Matematica B",level: level3)
Course.create(title: "Historia",level: level3)