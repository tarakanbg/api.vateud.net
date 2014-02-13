#encoding: utf-8
class Squawk < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("freq")

  set_table_name "squawks"

  attr_accessible :facility, :position, :start, :end

  default_scope order('facility ASC')

  scope :active, where('facility != "Free"')


  def self.to_csv(options = {})
    columns = ["facility", "position", "start", "end"]
    CSV.generate(options) do |csv|
      csv << columns
      active.each do |sq|
        csv << sq.attributes.values_at(*columns)
      end
    end
  end


end
