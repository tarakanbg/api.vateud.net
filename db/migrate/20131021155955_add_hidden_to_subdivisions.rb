class AddHiddenToSubdivisions < ActiveRecord::Migration
  def change
    add_column :subdivisions, :hidden, :boolean, :default => false
    add_column :subdivisions, :official, :boolean, :default => true
  end
end
