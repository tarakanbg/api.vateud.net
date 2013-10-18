class EventsController < ApplicationController
  def index
    @pagetitle = "Events Calendar"
    # @events = Event.select("title, subtitle, airports, banner_url, description, starts, ends").reorder("starts DESC")
    @events = Event.reorder("starts DESC")
    @search = Event.search(params[:q])
    @search.sorts = 'starts desc' if @search.sorts.empty?
    @events_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
    @json = @events.to_json(:except => [:id, :admin_user_id, :created_at, :updated_at], :include => { :subdivisions => {
                                               :only => :name } })
    @xml = @events.to_xml(:except => [:id, :admin_user_id, :created_at, :updated_at], :include => { :subdivisions => {
                                               :only => :name } }, skip_types: true)

    respond_to do |format|
      format.html
      format.json { render json: @json }
      format.xml { render xml: @xml }
      format.csv { send_data @events.to_csv }
    end
  end

  
  def show
    # @code = params[:id].upcase
    # @vacc = Subdivision.find_by_code(@code).name
    # @pagetitle = @vacc + " members"
    # @members = Member.where(["subdivision = ?", @code]).select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")
    
    # @search = Member.where(["subdivision = ?", @code]).search(params[:q])
    # @search.sorts = 'reg_date desc' if @search.sorts.empty?
    # @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)

    # respond_to do |format|
    #   format.html
    #   format.json { render json: @members }
    #   format.xml { render xml: @members.to_xml(skip_types: true) }
    #   format.csv { send_data @members.to_csv }
    # end
  end
end
