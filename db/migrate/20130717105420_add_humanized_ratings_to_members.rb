class AddHumanizedRatingsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :humanized_atc_rating, :string
    add_column :members, :humanized_pilot_rating, :string
    remove_column :members, :rating
    remove_column :members, :pilot_rating    
    add_column :members, :pilot_rating, :integer
    add_column :members, :rating, :integer    
  end
end
