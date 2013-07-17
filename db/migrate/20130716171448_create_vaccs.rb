class CreateVaccs < ActiveRecord::Migration
  def change
    create_table :vaccs do |t|
      t.string :country
      t.string :vacc

      t.timestamps
    end
  end
end
