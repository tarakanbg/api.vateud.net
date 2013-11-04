class CreateCustomChartSources < ActiveRecord::Migration
  def change
    create_table :custom_chart_sources do |t|
      t.integer :subdivision_id
      t.string :url

      t.timestamps
    end
  end
end
