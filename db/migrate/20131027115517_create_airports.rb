class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :icao
      t.integer :country_id
      t.boolean :major, :default => false

      t.timestamps
    end
  end
end
