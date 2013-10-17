class CreateSubdivisions < ActiveRecord::Migration
  def change
    create_table :subdivisions do |t|
      t.string :code
      t.string :name
      t.string :website
      t.text :introtext

      t.timestamps
    end
  end
end
