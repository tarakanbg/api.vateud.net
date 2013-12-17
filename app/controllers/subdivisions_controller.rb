class SubdivisionsController < ApplicationController

  caches_action :index, expires_in: 2.hours
  caches_action :show, expires_in: 2.hours
  
  def index
    @pagetitle = "vACC Codes"
    @vaccs = Subdivision.active.select("code, name, introtext, website, official").reorder("code ASC")
    @search = Subdivision.active.reorder("code ASC").search(params[:q])
    @search.sorts = 'code asc' if @search.sorts.empty?
    @subdivisions = @search.result(:distinct => true)

    respond_to do |format|
      format.html 
      format.json { render json: @vaccs }
      format.xml { render xml: @vaccs.as_json.to_xml(skip_types: true) }
      format.csv { send_data csv_data(@vaccs) }
    end
  end

  def show
    @code = params[:id].upcase
    if @vacc = Subdivision.where(["code = ?", @code]).select("code, name, introtext, website, official").first
      @pagetitle = @vacc.name + " details"
    end

    respond_to do |format|
      if @vacc
        format.html 
        format.json { render json: @vacc }
        format.xml { render xml: @vacc.as_json.to_xml(skip_types: true) }
        format.csv { send_data csv_single(@vacc) }
      else
        format.any { render :text => "Subdivision not in database" }
      end
    end
  end

private

  def csv_data(vaccs)    
    CSV.generate do |csv|
      csv << ["code", "name", "website", "introtext", "official"]
      vaccs.each do |vacc|
        csv << [vacc.code, vacc.name, vacc.website, vacc.introtext, vacc.official]
      end
    end
  end  

  def csv_single(vacc)    
    CSV.generate do |csv|
      csv << ["code", "name", "website", "introtext", "official"]
      csv << [vacc.code, vacc.name, vacc.website, vacc.introtext, vacc.official]
    end
  end

end