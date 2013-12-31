class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.references :level, index: true

      t.timestamps
    end
  end
end