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
    @icao = icao.upcase
    custom = CustomChart.where(:icao => @icao)
    @raw = raw_list
    return custom_charts(custom) if custom.count > 0
    return @charts = "No charts available" if @raw == "NADA"
    @plates = plates_list  
    @plate_names = plate_names
    @charts = [] 
    @overrides = ChartOverride.where(:icao => @icao)
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
    @raw.css('div.airport table td.col2 a').map { |link| link['href'] }
  end

  def plate_names
    @raw.css('div.airport table td.col2 a').map { |link| link.text }
  end

  def grouped_plates
    # cleanup_plates
    while @plates.count > 0
      url = @plates.shift unless @plates.first.include?("cache.charts.aero")
      name = @plate_names.shift unless @plate_names.first.include?("CACHED")
      if @plates.count > 0 && @plate_names.count > 0
        @plates.first.include?("cache.charts.aero") ? url_charts_aero = @plates.shift : url_charts_aero = nil
        @plate_names.first.include?("CACHED") ? name_charts_aero = @plate_names.shift : name_charts_aero = nil
      end
      @charts << Chart.new(icao = @icao, name = name, url_aip = url, url_charts_aero = url_charts_aero)
    end
    include_individual_custom_charts
  end

  # def cleanup_plates
  #   @plates.each do |plate|
  #     @plates.delete(plate) if plate.include?("cache.charts.aero")
  #   end
  #   @plate_names.each do |name|
  #     @plate_names.delete(name) if name.include?("CACHED")
  #   end
  # end

  def list_charts
    name_overrides
    @charts.sort_by!{ |c| c.name }
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

  def include_individual_custom_charts
    custom = IndividualCustomChart.where(:icao => @icao)
    if custom.count > 0
      for chart in custom
        @charts << Chart.new(icao = chart.icao, name = "#{chart.name} (CUSTOM)", url_aip = chart.url, url_charts_aero = "https://charts.aero/airport/#{chart.icao}")
      end
    end
  end

end