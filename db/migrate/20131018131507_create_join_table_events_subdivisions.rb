class CreateJoinTableEventsSubdivisions < ActiveRecord::Migration
  def change
    create_table :events_subdivisions do |t|
      t.integer :event_id
      t.integer :subdivision_id
    end
  end
  
end
