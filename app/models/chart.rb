class Chart 

  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Naming
  include ActiveModel::Callbacks


  @attributes = %w{icao name url_aip url_charts_aero}
  @attributes.each {|attribute| attr_accessor attribute.to_sym }

  def initialize(icao, name, url_aip, url_charts_aero, args = nil)
    @icao = icao.upcase
    @name = name
    @url_aip = url_aip
    @url_charts_aero = url_charts_aero
  end

end