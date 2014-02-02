class AddNestedSetToPages < ActiveRecord::Migration
  def change
    add_column :pages, :lft, :integer    
    add_column :pages, :rgt, :integer
    add_column :pages, :parent_id, :integer
    add_column :pages, :name, :string
    add_index :pages, :slug, :unique => true
  end
end
