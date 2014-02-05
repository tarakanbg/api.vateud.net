# #encoding: utf-8
# class Staff < ActiveRecord::Base

#   self.abstract_class = true

#   establish_connection("vateud")

#   set_table_name "staff_lists"

#   attr_accessible :vacc_code, :callsign, :cid, :Email, :position, :list_order
#   attr_accessor :name

#   default_scope order('callsign DESC')

#   has_one :member, :foreign_key => 'cid', :primary_key => 'cid'

#   belongs_to :subdivision, :primary_key => 'code', :foreign_key => 'vacc_code'

#   def name
#     if self.member
#         self.member.firstname + " " + self.member.lastname
#     else
#       "VACANT"
#     end
#   end

# end
