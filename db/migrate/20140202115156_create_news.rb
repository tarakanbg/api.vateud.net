class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.string :slug
      t.text :post, :default => "Edit here!"
      t.boolean :published, :default => true
      t.integer :author_id
      t.text :description, :default => "VATSIM European Division News"
      t.string :keywords, :default => "vatsim, vateud, news, simulation, flight, atc, vateur"

      t.timestamps
    end
  end
end
