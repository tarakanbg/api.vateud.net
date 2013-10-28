class FrequencyBridge < ActiveRecord::Base
  attr_accessible :country_id, :frequency_country_id, :notes

  belongs_to :country
  belongs_to :frequency_country


  rails_admin do 
    navigation_label 'API management'
  end
end
