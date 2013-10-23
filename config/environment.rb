# Load the rails application
require File.expand_path('../application', __FILE__)

# ENV['SSL_CERT_FILE'] = "/opt/certs/cacert.pem"
# ENV['SSL_CERT_FILE'] = File.join(File.dirname(__FILE__),"/opt/certs/cacert.pem")

# Initialize the rails application
Vaccs::Application.initialize!


