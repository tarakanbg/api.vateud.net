#encoding: utf-8
class Member < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "certificates"

end
