class OnlineController < ApplicationController
  caches_action :atc, :pilots, :arrivals, :departures, :callsign, :cache_path => Proc.new { |c| c.params }, expires_in: 5.minutes

  def index
    @pagetitle = "Online Stations"
  end

  def search
    filter = params[:q]
    redirect_to "/online/atc/#{filter}"
  end

  def search_callsign
    filter = params[:q]
    redirect_to "/online/callsign/#{filter}"
  end

  def help
    @pagetitle = "Documentation"
    m = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:with_toc_data => true))
    mtoc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
    @content = m.render(File.open(Rails.root + "HELP.md", 'r').read)
    @toc = mtoc.render(File.open(Rails.root + "HELP.md", 'r').read)
  end

  def atc
    @code = params[:id]
    subset = params[:subset]
    @pagetitle = "Who's online in #{@code.upcase}"
    @stations = []
    @code.vatsim_online[:atc].each {|station| @stations << Station.new(station)}

    respond_to do |format|
      format.html
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      if subset && subset == "crovacc"
        format.csv { send_data csv_atc_subset_data(@stations) }
      else
        format.csv { send_data csv_data(@stations) }
      end
    end
  end

  def pilots
    @code = params[:id]
    subset = params[:subset]
    @pagetitle = "Who's online in #{@code.upcase}"
    @stations = []
    @code.vatsim_online[:pilots].each {|station| @stations << Station.new(station) if station.role == "PILOT"}

    respond_to do |format|
      format.html
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      if subset && subset == "crovacc"
        format.csv { send_data csv_pilot_subset_data(@stations) }
      else
        format.csv { send_data csv_data(@stations) }
      end
    end
  end

  def arrivals
    @code = params[:id]
    @pagetitle = "Who's online in #{@code.upcase}"
    @stations = []
    @code.vatsim_online[:arrivals].each {|station| @stations << Station.new(station) if station.role == "PILOT"}

    respond_to do |format|
      format.html
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@stations) }
    end
  end

  def departures
    @code = params[:id]
    @pagetitle = "Who's online in #{@code.upcase}"
    @stations = []
    @code.vatsim_online[:departures].each {|station| @stations << Station.new(station) if station.role == "PILOT"}

    respond_to do |format|
      format.html
      format.json { render json: @stations }
      format.xml { render xml: @stations.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@stations) }
    end
  end

  def callsign
    @code = params[:id]
    @pagetitle = "Who's online by callsign: #{@code.upcase}"
    @stations = []
    @code.vatsim_callsign.each {|station| @stations << Station.new(station)}

    respond_to do |format|
      format.html
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

  def csv_atc_subset_data(stations)
    CSV.generate do |csv|
      csv << Station.csv_column_headers_subset_atc
      stations.each do |station|
        csv << station.csv_column_values_subset_atc
      end
    end
  end

  def csv_pilot_subset_data(stations)
    CSV.generate do |csv|
      csv << Station.csv_column_headers_subset_pilots
      stations.each do |station|
        csv << station.csv_column_values_subset_pilots
      end
    end
  end

end
