class RatingsController < ApplicationController

  caches_action :index, :cache_path => Proc.new { |c| c.params }, expires_in: 3.hours
  caches_action :show, :cache_path => Proc.new { |c| c.params }, expires_in: 4.hours

  def index
    @pagetitle = "Rating codes"

    respond_to do |format|
      format.html      
    end
  end

  def show
    @code = params[:id]
    @members = Member.where(["rating = ?", @code]).select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")
    @pagetitle = "Members by ATC rating"

    @search = Member.where(["rating = ?", @code]).search(params[:q])
    @search.sorts = 'reg_date desc' if @search.sorts.empty?
    @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      unless @members.count == 0
        format.html 
        format.json { render json: @members }
        format.xml { render xml: @members.to_xml(skip_types: true) }
        format.csv { send_data @members.to_csv }    
      else
        format.any { render :text => "No members found" }
      end
    end
  end

  
end
