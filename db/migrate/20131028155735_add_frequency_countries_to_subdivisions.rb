class AddFrequencyCountriesToSubdivisions < ActiveRecord::Migration
  def change
    add_column :subdivisions, :frequency_countries, :string
  end
end
