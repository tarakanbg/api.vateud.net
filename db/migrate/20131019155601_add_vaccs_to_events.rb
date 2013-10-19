class AddVaccsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :vaccs, :string
  end
end
