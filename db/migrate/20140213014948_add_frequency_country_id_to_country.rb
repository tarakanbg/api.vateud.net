class AddFrequencyCountryIdToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :frequency_country_id, :integer
  end
end
