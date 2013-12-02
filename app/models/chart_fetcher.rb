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
    custom = CustomChart.where(:icao => icao.upcase)
    @raw = raw_list
    return custom_charts(custom) if custom.count > 0
    return @charts = "No charts available" if @raw == "NADA"
    @plates = plates_list  
    @plate_names = plate_names
    @charts = [] 
    @overrides = ChartOverride.where(:icao => @icao.upcase)
    grouped_plates
    list_charts
  end

  def custom_charts(custom)
    @charts = []
    for chart in custom
      @charts << Chart.new(icao = chart.icao, name = chart.name, url_aip = chart.url, url_charts_aero = nil)
    end
  end

  def raw_list
    Nokogiri::HTML(open("https://charts.aero/airport/#{@icao}", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
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
    cleanup_plates
    # return "NADA" if @raw == "NADA"
    while @plates.count > 0
      url = @plates.shift
      # url_cached = @plates.shift if @plates.first.include?("charts.aero")
      # @plates.first.include?("charts.aero") ? url_cached = @plates.shift : url_cached = "https://charts.aero"
      name = @plate_names.shift
      # name_cached = @plate_names.shift if @plate_names.first.include?("CACHED")
      # @plate_names.first.include?("CACHED") ? name_cached = @plate_names.shift : name_cached = "No cached version"
      # @charts << Chart.new(icao = @icao, name = name, url_aip = url, url_charts_aero = url_cached)
      @charts << Chart.new(icao = @icao, name = name, url_aip = url, url_charts_aero = "https://charts.aero/airport/#{@icao}")
    end
  end

  def cleanup_plates
    @plates.each do |plate|
      @plates.delete(plate) if plate.include?("cache.charts.aero")
    end
    @plate_names.each do |name|
      @plate_names.delete(name) if name.include?("CACHED")
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