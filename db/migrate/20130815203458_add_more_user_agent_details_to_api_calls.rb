class AddMoreUserAgentDetailsToApiCalls < ActiveRecord::Migration
  def change
    add_column :api_calls, :request_format, :string
  end
end
