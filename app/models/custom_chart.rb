class CustomChart < ActiveRecord::Base
  attr_accessible :icao, :name, :url
  validates :icao, :url, :name, :presence => true

  rails_admin do 
    navigation_label 'Reference'
  end
end
