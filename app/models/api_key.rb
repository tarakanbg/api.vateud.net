class ApiKey < ActiveRecord::Base
  attr_accessible :access_token, :vacc_code
  before_create :generate_access_token

  has_paper_trail
  
private
  
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
