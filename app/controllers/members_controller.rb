class MembersController < ApplicationController
  
  # caches_action :index, expires_in: 3.hours
  # caches_action :show, expires_in: 4.hours
  caches_page :index, :if => Proc.new { |c| c.request.format.json? }, expires_in: 3.hours
  caches_page :index, :if => Proc.new { |c| c.request.format.xml? }, expires_in: 3.hours
  caches_page :index, :if => Proc.new { |c| c.request.format.csv? }, expires_in: 3.hours
  caches_page :show, :if => Proc.new { |c| c.request.format.csv? }, expires_in: 4.hours
  caches_page :show, :if => Proc.new { |c| c.request.format.json? }, expires_in: 4.hours
  caches_page :show, :if => Proc.new { |c| c.request.format.xml? }, expires_in: 4.hours

  def index
    @pagetitle = "Members list"
    @members = Member.select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")
    @search = Member.search(params[:q])
    @search.sorts = 'reg_date desc' if @search.sorts.empty?
    @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.json { render json: @members }
      format.xml { render xml: @members.to_xml(skip_types: true) }
      format.csv { send_data @members.to_csv }
    end
  end

  
  def show
    @code = params[:id].upcase
    @vacc = Subdivision.find_by_code(@code).name
    @pagetitle = @vacc + " members"
    @members = Member.where(["subdivision = ?", @code]).select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")
    
    @search = Member.where(["subdivision = ?", @code]).search(params[:q])
    @search.sorts = 'reg_date desc' if @search.sorts.empty?
    @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.json { render json: @members }
      format.xml { render xml: @members.to_xml(skip_types: true) }
      format.csv { send_data @members.to_csv }
    end
  end

  def validate
    cid = request.headers["cid"] if request.headers["cid"]
    email = request.headers["email"] if request.headers["email"]
    if cid && email
      member = Member.find_by_cid_and_email(cid, email)
    else
      member = nil
    end
    member.nil? ? @response_text = "0" : @response_text = "1"

    respond_to do |format|
      format.html {render :layout => false}
    end
  end

  def single
    @cid = params[:id]
    @member = Member.find_by_cid(@cid, :select => "cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date")
    @pagetitle = "User details for #{@member.cid}"

    respond_to do |format|
      format.html
      format.json { render json: @member }
      format.xml { render xml: @member.to_xml(skip_types: true) }
      format.csv { send_data @member.to_csv_single }
    end
  end

  
end
