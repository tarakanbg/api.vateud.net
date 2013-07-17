class ChangeMemberRatingTypes < ActiveRecord::Migration
  def up
    change_column :members, :rating, :string
    change_column :members, :pilot_rating, :string
  end

  def down
    change_column :members, :rating, :integer
    change_column :members, :pilot_rating, :integer
  end
end
