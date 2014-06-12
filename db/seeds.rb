# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Course.delete_all
Course.create(title: "Ciencias sociales")
Course.create(title: "Ciencias Matematicas")
Course.create(title: "Ingles")
Course.create(title: "Geografia")
Course.create(title: "Matematica B")
Course.create(title: "Historia")

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

