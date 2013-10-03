class CreateChartOverrides < ActiveRecord::Migration
  def change
    create_table :chart_overrides do |t|
      t.string :icao
      t.string :find_string
      t.string :replace_with

      t.timestamps
    end
  end
end
