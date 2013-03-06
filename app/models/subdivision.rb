#encoding: utf-8
class Subdivision < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "subdivisions"

  # has_one :vacc, :foreign_key => 'vacc', :primary_key => 'code'

  has_many :staff, :foreign_key => 'vacc_code', :primary_key => "code"

end
