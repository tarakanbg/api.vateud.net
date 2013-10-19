class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # require 'active_admin_views_pages_base.rb'
  require 'user_agent_parser'

  before_filter :log_api_call

  def log_api_call
    endpoint = controller_path
    parameters = params[:id] ? params[:id].upcase : nil
    ip = request.remote_ip
    user_agent = UserAgentParser.parse request.env["HTTP_USER_AGENT"]
    user_agent_name = user_agent.name if user_agent
    user_agent_version = user_agent.version.major if user_agent && user_agent.version
    os = user_agent.os.to_s if user_agent && user_agent.os
    request_format = request.format.symbol
    unless endpoint.include? "admin" or endpoint.include? "events" or user_agent_name == "Googlebot"
      ApiCall.create(endpoint: endpoint, ip: ip, parameters: parameters, user_agent: user_agent_name,
                   user_agent_version: user_agent_version, user_os: os, request_format: request_format)
    end
  end
end
