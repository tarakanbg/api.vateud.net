class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :cid
      t.integer :rating
      t.integer :pilot_rating
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :age_band
      t.string :state
      t.string :country
      t.string :experience
      t.string :susp_ends
      t.string :reg_date
      t.string :region
      t.string :division
      t.string :subdivision

      t.timestamps
    end
  end
end
