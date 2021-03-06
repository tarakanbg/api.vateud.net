class FrequenciesController < ApplicationController

  caches_action :index, expires_in: 2.hours
  caches_action :show, expires_in: 2.hours
  
  def index
    @pagetitle = "VATEUD approved ATC frequencies"
    @vaccs = Subdivision.active    
    @frequencies = Frequency.european
    respond_to do |format|
      format.html 
      format.json { render json: scope_json(@frequencies) }
      format.xml { render xml: scope_xml(@frequencies) }
      format.csv { send_data @frequencies.to_csv }
    end
  end
  
  def show
    @code = params[:id].upcase
    if @vacc = Subdivision.find_by_code(@code)
      @pagetitle = "Approved ATC frequencies for: #{@vacc.name}"
      @freqs = @vacc.frequencies
    end

    respond_to do |format|
      if @vacc
        format.html 
        format.json { render json: scope_json(@freqs) }
        format.xml { render xml: scope_xml(@freqs) }
        format.csv { send_data @freqs.to_csv_vacc(@freqs) }
      else
        format.any { render :text => "Non-existant subdivision" }
      end
    end
  end

private

  def scope_json(freqs)
    freqs.to_json(:only => [:callsign, :name, :freq])
  end

  def scope_xml(freqs)
    freqs.to_xml(:only =>  [:callsign, :name, :freq], skip_types: true)
  end
  
end
