class AddPageEditorToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :page_editor, :boolean, :default => false
  end
end
