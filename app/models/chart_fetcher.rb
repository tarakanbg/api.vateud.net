class ChartFetcher

  require 'nokogiri'
  require 'open-uri'

  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Naming
  include ActiveModel::Callbacks


  @attributes = %w{icao plates charts plate_names}
  @attributes.each {|attribute| attr_accessor attribute.to_sym }

  def initialize(icao, args = nil)
    # process_arguments(args) if args.class == Hash
    @icao = icao
    @plates = plates_list  
    @plate_names = plate_names
    @charts = [] 
    grouped_plates
    list_charts
  end

  def raw_list
    Nokogiri::HTML(open("http://charts.aero/airport/#{@icao}"))
  end

  def plates_list
    self.raw_list.css('div.airport table td.col2 a').map { |link| link['href'] }
  end

  def plate_names
    self.raw_list.css('div.airport table td.col2 a').map { |link| link.text }
  end

  def grouped_plates
    while @plates.count > 0
      url = @plates.shift
      url_cached = @plates.shift
      name = @plate_names.shift
      name_cached = @plate_names.shift
      @charts << Chart.new(icao = @icao, name = name, url_aip = url, url_charts_aero = url_cached)
    end
  end

  def list_charts
    @charts
  end


  # def self.csv_column_headers
  #   ["role", "callsign"]
  # end

  # def csv_column_values
  #   [self.role, self.callsign]
  # end
end