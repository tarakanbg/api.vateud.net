# This migration comes from airdata (originally 20120729093820)
class CreateAirdataRunways < ActiveRecord::Migration
  def change
    create_table :airdata_runways do |t|
      t.integer :airport_id
      t.integer :number
      t.integer :course
      t.integer :length
      t.boolean :ils
      t.float :ils_freq
      t.integer :ils_fac
      t.float :lat
      t.float :lon
      t.integer :elevation
      t.float :glidepath

      t.timestamps
    end
  end
end
