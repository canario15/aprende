class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|
      t.string :name
      t.string :contact
      t.string :email
      t.string :phone
      t.references :city, index: true

      t.timestamps
    end
  end
end
