# This migration comes from airdata (originally 20130131161413)
class ChangeNumberFormatInAirdataRunways < ActiveRecord::Migration
  def up
    change_column :airdata_runways, :number, :string
  end

  def down
    change_column :airdata_runways, :number, :integer
  end
end
