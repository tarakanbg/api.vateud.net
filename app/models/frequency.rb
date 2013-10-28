#encoding: utf-8
class Frequency < ActiveRecord::Base

  self.abstract_class = true
  self.inheritance_column = :_type_disabled

  establish_connection("freq")
  
  set_table_name "frequencies"

  attr_accessible :id, :country, :name, :airport, :callsign, :freq

  default_scope order('callsign DESC')

  belongs_to :frequency_country, :foreign_key => 'id', :primary_key => "country"

  # has_one :vacc, :foreign_key => 'vacc', :primary_key => 'code'

  # has_many :staff, :foreign_key => 'vacc_code', :primary_key => "code"

end
