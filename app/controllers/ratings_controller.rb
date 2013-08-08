class RatingsController < ApplicationController

  caches_action :index, expires_in: 3.hours
  caches_action :show, expires_in: 4.hours

  def index
    @pagetitle = "Rating codes"

    respond_to do |format|
      format.html      
    end
  end

  def show
    @code = params[:id]
    @members = Member.where(["rating = ?", @code]).select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")

    # @country = Country.find_by_code(@code).name
    @pagetitle = "Members by ATC rating"
    # @members = Member.where(["country = ?", params[:id].upcase]).select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")

    @search = Member.where(["rating = ?", @code]).search(params[:q])
    @search.sorts = 'reg_date desc' if @search.sorts.empty?
    @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html #{ render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @members }
      format.xml { render xml: @members.to_xml(skip_types: true) }
      format.csv { send_data @members.to_csv }    
    end
  end

  
end
