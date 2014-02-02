class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.string :name
      t.integer :priority

      t.timestamps
    end
  end
end
