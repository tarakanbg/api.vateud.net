class CreateApiCalls < ActiveRecord::Migration
  def change
    create_table :api_calls do |t|
      t.string :endpoint
      t.string :parameters
      t.string :ip
      t.string :user_agent

      t.timestamps
    end
  end
end
