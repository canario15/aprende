class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.references :containable, polymorphic: true
      t.timestamps
    end
  end
end