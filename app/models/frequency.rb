#encoding: utf-8
class Frequency < ActiveRecord::Base

  self.abstract_class = true
  self.inheritance_column = :_type_disabled

  establish_connection("freq")
  
  set_table_name "frequencies"

  attr_accessible :id, :country, :name, :airport, :callsign, :freq

  default_scope order('callsign ASC')

  belongs_to :frequency_country, :foreign_key => 'id', :primary_key => "country"

  excluded_ids = [40,41,42,43]

  scope :european, where("country NOT IN (?)", excluded_ids)

  # has_one :vacc, :foreign_key => 'vacc', :primary_key => 'code'

  # has_many :staff, :foreign_key => 'vacc_code', :primary_key => "code"

  def self.to_csv(options = {})
    columns = ["callsign", "name", "freq"]
    CSV.generate(options) do |csv|
      csv << columns
      european.each do |freq|
        csv << freq.attributes.values_at(*columns)
      end
    end
  end

  def self.to_csv_vacc(freqs, options = {})
    columns = ["callsign", "name", "freq"]
    CSV.generate(options) do |csv|
      csv << columns
      freqs.each do |freq|
        csv << freq.attributes.values_at(*columns)
      end
    end
  end
  

end
