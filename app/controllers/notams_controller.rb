class NotamsController < ApplicationController
  caches_action :index, :show, expires_in: 24.hours

  def index
    @pagetitle = "NOTAMs"
  end

  def search
    filter = params[:q]
    redirect_to "/notams/#{filter}"
  end

  def show
    @code = params[:id]
    @notams = @code.notams(:objects => true)
    @pagetitle = "NOTAMs for #{@code.upcase}"

    respond_to do |format|
      format.html 
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
