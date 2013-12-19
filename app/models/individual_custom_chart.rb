class IndividualCustomChart < ActiveRecord::Base
  attr_accessible :icao, :name, :url
  validates :icao, :name, :url, :presence => true
  validates_length_of :icao, :maximum => 4, :minimum => 4

  before_save :upcase_icao

  def upcase_icao
    self.icao = self.icao.upcase
  end

  rails_admin do 
    navigation_label 'Charts'
  end
end
