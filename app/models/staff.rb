#encoding: utf-8
class Staff < ActiveRecord::Base  

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "staff_lists"

  attr_accessible :vacc_code, :callsign, :cid, :Email, :position, :list_order

  has_one :member, :foreign_key => 'cid', :primary_key => 'cid'

  belongs_to :subdivision, :primary_key => 'code', :foreign_key => 'vacc_code'

end
