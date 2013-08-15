class ApiCall < ActiveRecord::Base
  attr_accessible :endpoint, :ip, :parameters, :user_agent, :user_agent_version, :user_os, :request_format
end
