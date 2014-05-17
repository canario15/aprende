# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Level.delete_all
level1 = Level.create(title: "Primer año")
level2 = Level.create(title: "Segundo año")
level3 = Level.create(title: "Tercer año")

Course.delete_all
Course.create(title: "Ciencias sociales",level: level1)
Course.create(title: "Ciencias Matematicas",level: level1)
Course.create(title: "Ingles",level: level2)
Course.create(title: "Geografia",level: level2)
Course.create(title: "Matematica B",level: level3)
Course.create(title: "Historia",level: level3)

State.delete_all
['Montevideo','Canelones  ', 'Maldonado ','Salto  ','Colonia  ',
  'Paysandú ','San José ','Rivera ','Tacuarembó ','Cerro Largo  ',
  'Soriano  ','Artigas  ','Rocha  ','Florida  ','Lavalleja  ',
  'Durazno  ','Río Negro  ','Treinta y Tres ','Flores'].each.with_index do |state, i|
  state = State.new(name: state.strip)
  state.id = i+1
  state.save
end

Admin.delete_all
Admin.create!(email: "admin@vairix.com", password: "123456789")

City.delete_all
City.create!(name: "Montevideo", state_id: 1)
City.create!(name: "Pan de Azucar", state_id: 3)
City.create!(name: "Maldonado", state_id: 3)

