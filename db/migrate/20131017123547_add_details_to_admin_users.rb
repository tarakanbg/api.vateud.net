class AddDetailsToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :name, :string
    add_column :admin_users, :vatsimid, :integer
    add_column :admin_users, :subdivision_id, :integer
    add_column :admin_users, :position, :string
  end
end
