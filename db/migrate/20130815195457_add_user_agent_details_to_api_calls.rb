class AddUserAgentDetailsToApiCalls < ActiveRecord::Migration
  def change
    add_column :api_calls, :user_agent_version, :string
    add_column :api_calls, :user_os, :string
  end
end
