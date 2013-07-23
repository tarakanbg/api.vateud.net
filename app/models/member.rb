#encoding: utf-8
class Member < ActiveRecord::Base
  attr_accessible :cid, :firstname, :lastname, :email, :rating, :pilot_rating, :humanized_atc_rating, :humanized_pilot_rating,
    :region, :country, :state, :division, :subdivision, :age_band, :experience, :reg_date, :susp_ends

  has_one :welcome_email

  after_create :create_welcome_email  

  LOCAL_CSV = "#{Dir.tmpdir}/vatsim_csv.csv"

  def create_welcome_email
    WelcomeEmail.create(member_id: self.id)
  end

  def self.to_csv(options = {})
    columns = ["cid", "firstname", "lastname", "rating", "humanized_atc_rating", "pilot_rating", "humanized_pilot_rating", "country", "subdivision", "reg_date"]
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |member|
        csv << member.attributes.values_at(*columns)
      end
    end
  end

  def self.to_csv_with_emails(options = {})
    columns = ["cid", "firstname", "lastname", "email", "rating", "humanized_rating", "pilot_rating", "humanized_pilot_rating", "country", "subdivision", "reg_date", "susp_ends"]
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |member|
        csv << member.attributes.values_at(*columns)
      end
    end
  end

  def self.humanized_rating(rating)    
    case rating
      when "0" then "Suspended"
      when "1" then "OBS"
      when "2" then "S1"
      when "3" then "S2"
      when "4" then "S3"
      when "5" then "C1"
      when "7" then "C3"
      when "8" then "INS"
      when "10" then "INS+"
      when "11" then "Supervisor"
      when "12" then "Administrator"
      else
        "UNK"
    end
  end

  def self.humanized_pilot_rating(pilot_rating)    
    case pilot_rating
      when "0" then "P0"
      when "1" then "P1"
      when "3" then "P1, P2"
      when "4" then "P3"
      when "5" then "P1, P3"
      when "7" then "P1, P2, P3"
      when "9" then "P1, P4"
      when "11" then "P1, P2, P4"
      when "15" then "P1, P2, P3, P4"
      when "27" then "P1, P2, P4, P5"
      when "31" then "P1, P2, P3, P4, P5"
      when "59" then "P1, P2, P4, P5, P6"
      when "63" then "P1, P2, P3, P4, P5, P6"
      else
        "UNK"
      end
  end

  def self.request_csv
    csv = Curl::Easy.http_post("https://cert.vatsim.net/vatsimnet/admin/divdbfullwpilot.php",
      Curl::PostField.content('authid', '400201'),
      Curl::PostField.content('authpassword', 'dp4w67f'),
      Curl::PostField.content('div', 'EUD'))
    # csv.body_str.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '?').encode!('UTF-8', 'UTF-16').gsub!('"', '')
    csv.body_str.gsub!('"', '').force_encoding('UTF-8').encode!('UTF-8', 'UTF-8', :invalid => :replace)
  end

  def self.parse_csv
    Member.create_local_data_file
    CSV.foreach(LOCAL_CSV, encoding: "windows-1250:utf-8") do |row| 
      member = Member.find_by_cid(row[0]) || Member.new(:cid => row[0])
      member.update_attributes!(:rating => row[1], :humanized_atc_rating => Member.humanized_rating(row[1]),
        :pilot_rating => row[2], :humanized_pilot_rating => Member.humanized_pilot_rating(row[2]),
        :firstname => (row[3].titleize if row[3]), :lastname => (row[4].titleize if row[4]),
        :email => row[5], :age_band => row[6], :state => row[7], :country => row[8], :experience => row[9],
        :susp_ends => row[10], :reg_date => row[11], :region => row[12], :division => row[13], :subdivision => row[14])
    end
  end

  def self.create_local_data_file
    data = Tempfile.new('vatsim_csv', :encoding => 'UTF-8')
    File.rename data.path, LOCAL_CSV
    File.open(LOCAL_CSV, "w+") {|f| f.write(Member.request_csv)}
    File.chmod(0777, LOCAL_CSV)
  end

  
end
