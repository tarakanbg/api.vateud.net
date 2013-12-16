class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
