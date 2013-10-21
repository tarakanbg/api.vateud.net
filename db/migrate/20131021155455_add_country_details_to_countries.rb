class AddCountryDetailsToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :eud, :boolean, :default => false
    add_column :countries, :subdivision_id, :integer
  end
end
