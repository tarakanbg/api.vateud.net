class AddInCertToMembers < ActiveRecord::Migration
  def change
    add_column :members, :in_cert, :boolean, :default => false
  end
end
