class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :subtitle
      t.datetime :starts
      t.datetime :ends
      t.string :banner_url
      t.text :description
      t.string :airports

      t.timestamps
    end
  end
end
