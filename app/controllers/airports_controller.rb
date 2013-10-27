class AirportsController < ApplicationController

  caches_action :index, expires_in: 10.minutes
  caches_action :show, expires_in: 10.minutes  
  caches_action :country, expires_in: 10.minutes  
  
  def index
    @pagetitle = "VATEUD airports"
    @countries = Country.where(:eud => true).reorder("code ASC")    
    @airports = Airport.order("icao DESC") 
    respond_to do |format|
      format.html 
      format.json { render json: scope_json(@airports) }
      format.xml { render xml: scope_xml(@airports) }
      format.csv { send_data @airports.to_csv }
    end
  end

  def country
    @code = params[:id].upcase
    @country = Country.find_by_code(@code)
    @pagetitle = "Airports for country: #{@country.name}"
    @airports = @country.airports.order("icao DESC") 
    respond_to do |format|
      format.html 
      format.json { render json: scope_json(@airports) }
      format.xml { render xml: scope_xml(@airports) }
      format.csv { send_data @airports.to_csv }
    end
  end
  
  def show
    @code = params[:id].upcase
    @airport =Airport.find_by_icao(@code)
    @pagetitle = "Airport details for: #{@airport.icao} (#{@airport.country.name})"
    

    respond_to do |format|
      format.html 
      format.json { render json: scope_json(@airport) }
      format.xml { render xml: scope_xml(@airport) }
      format.csv { send_data @airport.to_csv_single }
    end
  end

private

  def scope_json(airports)
    airports.to_json(:only => [:icao, :iata, :major, :scenery_fs9_link, :scenery_fsx_link,
      :scenery_xp_link, :description], :include => { :country => {:only => [:code, :name]},
      :data => { :only => [:ta, :name, :elevation,
      :icao, :lat, :lon, :msa], :include => {:runways => {:only => [:course, :elevation, :glidepath,
      :ils, :ils_fac, :ils_freq, :lat, :length, :lon, :number] } } } })
  end

  def scope_xml(airports)
    airports.to_xml(:only => [:icao, :iata, :major, :scenery_fs9_link, :scenery_fsx_link,
      :scenery_xp_link, :description], :include => { :country => {:only => [:code, :name]},
      :data => { :only => [:ta, :name, :elevation,
      :icao, :lat, :lon, :msa], skip_types: true, :include => {:runways => {:only => [:course, :elevation, :glidepath,
      :ils, :ils_fac, :ils_freq, :lat, :length, :lon, :number], skip_types: true } } } }, skip_types: true)
  end
  
end
