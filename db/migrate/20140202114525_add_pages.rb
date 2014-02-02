class AddPages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :post, :default => "Edit here!"
      t.text :sidebar, :default => "Edit here!"
      t.string :slug
      t.text :description, :default => "VATSIM European Division"
      t.string :keywords, :default => "vatsim, vateud, simulation, flight, atc, vateur"
      t.boolean :abstract, :default => false
      t.boolean :visible, :default => true
      t.boolean :menu, :default => true

      t.timestamps
    end
  end
end
