#encoding: utf-8
class Member < ActiveRecord::Base

  self.abstract_class = true

  establish_connection("vateud")
  
  set_table_name "certificates"

  def self.to_csv(options = {})
    columns = ["cid", "firstname", "lastname", "rating", "country", "subdivision", "reg_date"]
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

  def firstname
    read_attribute(:firstname).capitalize
  end

  def lastname
    read_attribute(:lastname).capitalize
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

  # def humanized_subdivision(subdivision) 
  #   unless subdivision.blank?   
  #     Subdivision.find_by_code(subdivision.to_s).name      
  #   else
  #     ""
  #   end
  #   rescue NoMethodError
  #     ""
  #   # rescue ActiveRecord::RecordNotFound
  #   # ""
  # end

end
