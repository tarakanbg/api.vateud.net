class ChartsController < ApplicationController
  caches_action :show, expires_in: 2.hours

  def index
    @pagetitle = "Charts"
  end

  def search
    filter = params[:q]
    redirect_to "/charts/#{filter}"
  end

  def show
    @code = params[:id].downcase
    @charts = ChartFetcher.new(@code).charts
    @pagetitle = "Charts for #{@code.upcase}"

    respond_to do |format|
      format.html 
      format.json { render json: @charts }
      format.xml { render xml: @charts.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@charts) }
    end
  end

private

  def csv_data(charts)    
    CSV.generate do |csv|
      csv << ["icao", "name", "url_aip", "url_charts_aero"]
      charts.each do |chart|
        csv << [chart.icao, chart.name, chart.url_aip, chart.url_charts_aero]
      end
    end
  end  
end
