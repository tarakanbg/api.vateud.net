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
    @raw = raw_list
    return @charts = "No charts available" if @raw == "NADA"
    @plates = plates_list  
    @plate_names = plate_names
    @charts = [] 
    @overrides = ChartOverride.where(:icao => @icao.upcase)
    grouped_plates
    list_charts
  end

  def raw_list
    Nokogiri::HTML(open("http://charts.aero/airport/#{@icao}"))
  rescue RuntimeError
    "NADA"
  end

  def plates_list
    # return "NADA" if @raw == "NADA"
    @raw.css('div.airport table td.col2 a').map { |link| link['href'] }
  end

  def plate_names
    # return "NADA" if @raw == "NADA"
    @raw.css('div.airport table td.col2 a').map { |link| link.text }
  end

  def grouped_plates
    # return "NADA" if @raw == "NADA"
    while @plates.count > 0
      url = @plates.shift
      # url_cached = @plates.shift if @plates.first.include?("charts.aero")
      @plates.first.include?("charts.aero") ? url_cached = @plates.shift : url_cached = "http://charts.aero"
      name = @plate_names.shift
      # name_cached = @plate_names.shift if @plate_names.first.include?("CACHED")
      @plate_names.first.include?("CACHED") ? name_cached = @plate_names.shift : name_cached = "No cached version"
      @charts << Chart.new(icao = @icao, name = name, url_aip = url, url_charts_aero = url_cached)
    end
  end

  def list_charts
    name_overrides
    @charts
  end

  def name_overrides
    if @overrides
      apply_overrides
    end
  end

  def apply_overrides
    @overrides.each do |orr|
      @charts.each do |chart|
        chart.name.gsub!(orr.find_string, orr.replace_with)
      end
    end
  end





  # def self.csv_column_headers
  #   ["role", "callsign"]
  # end

  # def csv_column_values
  #   [self.role, self.callsign]
  # end
end