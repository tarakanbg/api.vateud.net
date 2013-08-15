class Chart 

  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Naming
  include ActiveModel::Callbacks


  @attributes = %w{icao name url_aip url_charts_aero}
  @attributes.each {|attribute| attr_accessor attribute.to_sym }

  def initialize(icao, name, url_aip, url_charts_aero, args = nil)
    # process_arguments(args) if args.class == Hash
    @icao = icao.upcase
    @name = name
    @url_aip = url_aip
    @url_charts_aero = url_charts_aero
    
  end

  # def raw_list
  #   Nokogiri::HTML(open("http://charts.aero/airport/#{@icao}"))
  # end

  # def plates_list
  #   @plates = self.raw_list.css('div.airport table td.col2 a').map { |link| link['href'] }
  # end


  # def self.csv_column_headers
  #   ["role", "callsign"]
  # end

  # def csv_column_values
  #   [self.role, self.callsign]
  # end
end