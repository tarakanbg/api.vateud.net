#encoding: utf-8
class Vacc < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "lut_country_vacc"

  # has_one :country, :foreign_key => 'code', :primary_key => 'country'

end
