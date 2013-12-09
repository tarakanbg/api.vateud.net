class CreateIndividualCustomCharts < ActiveRecord::Migration
  def change
    create_table :individual_custom_charts do |t|
      t.string :icao
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
