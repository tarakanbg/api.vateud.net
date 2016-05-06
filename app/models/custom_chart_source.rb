class CustomChartSource < ActiveRecord::Base
  attr_accessible :subdivision_id, :url

  belongs_to :subdivision

  validates :subdivision_id, :url, :presence => true

  LOCAL_CUSTOM_CHARTS = "#{Dir.tmpdir}/local_charts_csv.csv"

  rails_admin do 
    navigation_label 'Charts'
  end

  def self.import_charts
    CustomChart.destroy_all
    sources = CustomChartSource.all
    for source in sources
      CustomChartSource.create_local_data_file(source)
      CustomChartSource.process_source
    end
  end

  def self.process_source
    CSV.foreach(LOCAL_CUSTOM_CHARTS, encoding: "iso-8859-1:utf-8") do |row|       
      CustomChart.create(icao: row[0].upcase, name: row[3], url: row[10])
    end
  end

  def self.request_csv(source)
    begin
      csv = Curl::Easy.http_get(source.url).body_str
      csv.gsub!(',', ';') if csv.include? ","
      csv.gsub!('|', ',').force_encoding('UTF-8').encode!('UTF-8', 'UTF-8', :invalid => :replace)
    rescue
      msg = "TODO"
    end
  end

  def self.create_local_data_file(source)
    begin
      File.delete(LOCAL_CUSTOM_CHARTS) if File.exist?(LOCAL_CUSTOM_CHARTS)
      data = Tempfile.new('local_charts_csv', :encoding => 'UTF-8')
      File.rename data.path, LOCAL_CUSTOM_CHARTS
      File.open(LOCAL_CUSTOM_CHARTS, "w+") {|f| f.write(CustomChartSource.request_csv(source))}
      File.chmod(0777, LOCAL_CUSTOM_CHARTS)
    rescue
      msg = "TODO"
    end
  end
end
