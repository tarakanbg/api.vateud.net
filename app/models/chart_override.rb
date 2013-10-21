class ChartOverride < ActiveRecord::Base
  attr_accessible :find_string, :icao, :replace_with

  rails_admin do 
    navigation_label 'API management'
  end
end
