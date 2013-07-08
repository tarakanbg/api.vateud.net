#encoding: utf-8
class Member < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "certificates"

  def self.to_csv(options = {})
    columns = ["cid", "firstname", "lastname", "rating", "pilot_rating", "country", "subdivision", "reg_date"]
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |member|
        csv << member.attributes.values_at(*columns)
      end
    end
  end

  def self.to_csv_with_emails(options = {})
    columns = ["cid", "firstname", "lastname", "email", "rating", "pilot_rating", "country", "subdivision", "reg_date"]
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |member|
        csv << member.attributes.values_at(*columns)
      end
    end
  end

  def rating
    humanized_rating(read_attribute(:rating))
  end

  def pilot_rating
    humanized_pilot_rating(read_attribute(:pilot_rating))
  end

  def firstname
    read_attribute(:firstname).titleize
  end

  def lastname
    read_attribute(:lastname).titleize
  end

  # def subdivision
  #   humanized_subdivision(read_attribute(:subdivision))
  # end

  def humanized_rating(rating)    
    case rating
      when 0 then "Suspended"
      when 1 then "OBS"
      when 2 then "S1"
      when 3 then "S2"
      when 4 then "S3"
      when 5 then "C1"
      when 7 then "C3"
      when 8 then "INS"
      when 10 then "INS+"
      when 11 then "Supervisor"
      when 12 then "Administrator"
      else
        "UNK"
      end
  end

  def humanized_pilot_rating(pilot_rating)    
    case pilot_rating
      when 0 then "P0"
      when 1 then "P1"
      when 3 then "P1, P2"
      when 4 then "P3"
      when 5 then "P1, P3"
      when 7 then "P1, P2, P3"
      when 9 then "P1, P4"
      when 11 then "P1, P2, P4"
      when 15 then "P1, P2, P3, P4"
      when 31 then "P1, P2, P3, P4, P5"
      else
        "UNK"
      end
  end

  
end
