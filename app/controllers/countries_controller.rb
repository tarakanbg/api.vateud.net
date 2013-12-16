class CountriesController < ApplicationController

  caches_action :index, :cache_path => Proc.new { |c| c.params }, expires_in: 3.hours
  caches_action :show, :cache_path => Proc.new { |c| c.params }, expires_in: 4.hours

  # caches_page :index, :if => Proc.new { |c| c.request.format.json? }, expires_in: 3.hours
  # caches_page :index, :if => Proc.new { |c| c.request.format.xml? }, expires_in: 3.hours
  # caches_page :index, :if => Proc.new { |c| c.request.format.csv? }, expires_in: 3.hours
  # caches_page :show, :if => Proc.new { |c| c.request.format.csv? }, expires_in: 4.hours
  # caches_page :show, :if => Proc.new { |c| c.request.format.json? }, expires_in: 4.hours
  # caches_page :show, :if => Proc.new { |c| c.request.format.xml? }, expires_in: 4.hours
  
  def index
    @pagetitle = "Country codes"
    @search = Country.reorder("code ASC").search(params[:q])
    @search.sorts = 'code asc' if @search.sorts.empty?
    @countries = @search.result(:distinct => true)

    respond_to do |format|
      format.html 
    end
  end
  
  def show
    @code = params[:id].upcase
    if @country_record = Country.find_by_code(@code)
      @country = @country_record.name
      @pagetitle = "Members from " + @country
      @members = Member.where(["country = ?", params[:id].upcase]).select("cid, firstname, lastname,
        rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country,
        subdivision, reg_date").reorder("reg_date DESC")

      @search = Member.where(["country = ?", @code]).search(params[:q])
      @search.sorts = 'reg_date desc' if @search.sorts.empty?
      @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
    end

    respond_to do |format|
      if @country
        format.html 
        format.json { render json: @members }
        format.xml { render xml: @members.to_xml(skip_types: true) }
        format.csv { send_data @members.to_csv }
      else
        format.any { render :text => "Country not in database" }
      end
    end
  end

  
end
