class AddLayoutIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :layout_id, :integer
  end
end
