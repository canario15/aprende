class CreateTableInstitutesTeachersAsociation < ActiveRecord::Migration
  def change
    create_table :institutes_teachers do |t|
      t.integer :institute_id
      t.integer :teacher_id
    end
    add_index :institutes_teachers, :institute_id
    add_index :institutes_teachers, :teacher_id
  end
end