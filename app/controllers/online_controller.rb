class OnlineController < ApplicationController
  caches_action :atc, :pilots, :arrivals, :departures, expires_in: 5.minutes

  def help
    m = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @content = m.render(File.open(Rails.root + "README.md", 'r').read)
    # render :text => content
  end

  def atc
    @stations = []
    params[:id].vatsim_online[:atc].each {|station| @stations << Station.new(station)}

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@stations) }
    end
  end

  def pilots
    @stations = []
    params[:id].vatsim_online[:pilots].each {|station| @stations << Station.new(station) if station.role == "PILOT"}

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@stations) }
    end
  end

  def arrivals
    @stations = []
    params[:id].vatsim_online[:arrivals].each {|station| @stations << Station.new(station) if station.role == "PILOT"}

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@stations) }
    end
  end

  def departures
    @stations = []
    params[:id].vatsim_online[:departures].each {|station| @stations << Station.new(station) if station.role == "PILOT"}

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@stations) }
    end
  end

private

  def csv_data(stations)    
    CSV.generate do |csv|
      csv << Station.csv_column_headers
      stations.each do |station|
        csv << station.csv_column_values
      end
    end
  end
end
