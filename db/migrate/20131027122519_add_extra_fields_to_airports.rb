class AddExtraFieldsToAirports < ActiveRecord::Migration
  def change
    add_column :airports, :scenery_fs9_link, :string
    add_column :airports, :scenery_fsx_link, :string
    add_column :airports, :scenery_xp_link, :string
    add_column :airports, :iata, :string
    add_column :airports, :description, :text
  end
end
