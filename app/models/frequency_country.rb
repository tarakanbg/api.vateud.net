#encoding: utf-8
class FrequencyCountry < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("freq")
  
  set_table_name "countries"

  attr_accessible :id, :country

  default_scope order('country DESC')

  has_many :frequencies, :foreign_key => 'country', :primary_key => "id"
  

  # has_one :vacc, :foreign_key => 'vacc', :primary_key => 'code'

  # has_many :staff, :foreign_key => 'vacc_code', :primary_key => "code"

end
