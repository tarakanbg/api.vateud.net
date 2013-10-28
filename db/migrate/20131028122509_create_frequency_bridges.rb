class CreateFrequencyBridges < ActiveRecord::Migration
  def change
    create_table :frequency_bridges do |t|
      t.integer :country_id
      t.integer :frequency_country_id
      t.string :notes

      t.timestamps
    end
  end
end
