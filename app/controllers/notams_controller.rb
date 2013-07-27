class NotamsController < ApplicationController
  caches_action :index, :show, expires_in: 24.hours

  def index

  end

  def show
    @notams = params[:id].notams(:objects => true)

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @notams }
      format.xml { render xml: @notams.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@notams) }
    end
  end

private

  def csv_data(notams)    
    CSV.generate do |csv|
      csv << ["icao", "message", "raw"]
      notams.each do |notam|
        csv << [notam.icao, notam.message, notam.raw]
      end
    end
  end  
end
