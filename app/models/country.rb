#encoding: utf-8
class Country < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "lut_country_name"

  # has_one :vacc, :foreign_key => 'country'

end
