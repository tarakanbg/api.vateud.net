class EventsController < ApplicationController
  before_filter :restrict_access, :only => [:create, :update, :destroy]

  caches_action :show, expires_in: 10.minutes
  caches_action :index, :cache_path => Proc.new { |c| c.params }, expires_in: 10.minutes
  caches_action :vacc, :cache_path => Proc.new { |c| c.params }, expires_in: 10.minutes

  def index
    @pagetitle = "Events Calendar"
    @events = Event.future
    @search = Event.future.search(params[:q])
    @search.sorts = 'starts asc' if @search.sorts.empty?
    @events_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)

    @json = @events.to_json(:except => [:created_at, :updated_at, :weekly], :include => { :subdivisions => {
                                               :only => [:code, :name] } })
    @xml = @events.to_xml(:except => [:created_at, :updated_at, :weekly], :include => { :subdivisions => {
                                               :only => [:code, :name] } }, skip_types: true)

    respond_to do |format|
      format.html
      format.json { render json: @json }
      format.xml { render xml: @xml }
      format.csv { send_data @events.to_csv }
      format.ics { send_data Event.calendar(@events) }
    end
  end


  def show
    @pagetitle = "Event Details"
    if @event = Event.find(params[:id])
      @json = @event.to_json(:except => [:created_at, :updated_at, :weekly], :include => { :subdivisions => {
                                                 :only => [:code, :name] } })
      @xml = @event.to_xml(:except => [:created_at, :updated_at, :weekly], :include => { :subdivisions => {
                                                 :only => [:code, :name] } }, skip_types: true)
    end

    respond_to do |format|
      if @event
        format.html
        format.json { render json: @json }
        format.xml { render xml: @xml }
        format.csv { send_data @event.to_csv_single }
        format.ics { send_data Event.calendar_single(@event) }
      else
        format.any { render :text => "Event not in database" }
      end
    end
  end

  def vacc
    @code = params[:id].upcase
    if @vacc = Subdivision.find_by_code(@code)
      @pagetitle = "Events for #{@vacc.name}"
      @events = @vacc.events
      @search = @events.search(params[:q])
      @search.sorts = 'starts desc' if @search.sorts.empty?
      @events_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
      @json = @events.to_json(:except => [:created_at, :updated_at, :weekly], :include => { :subdivisions => {
                                                 :only => [:code, :name] } })
      @xml = @events.to_xml(:except => [:created_at, :updated_at, :weekly], :include => { :subdivisions => {
                                                 :only => [:code, :name] } }, skip_types: true)
    end

    respond_to do |format|
      if @vacc
        format.html
        format.json { render json: @json }
        format.xml { render xml: @xml }
        format.csv { send_data @events.to_csv }
        format.ics { send_data Event.calendar(@events) }
      else
        format.any { render :text => "VACC not in database" }
      end
    end
  end

  def create
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end

    @event = Event.new(params[:event])
    @event.vaccs = @key.vacc_code.upcase
    if @event.save
      respond_to do |format|
        format.json{render :json => @event, :status => :created }
      end
    else
      format.json { render json: @event.errors, status: :unprocessable_entity }
    end
  end

  def update
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end

    @event = Event.find(params[:id])
    vacc_codes = []
    @event.subdivisions.each {|sub| vacc_codes << sub.code.upcase}
    render text: "No joy! Your access token does not match the event vaccs" and return unless vacc_codes.include? @key.vacc_code.upcase
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.json { render :json => @event, :status => :updated }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end

    @event = Event.find(params[:id])
    vacc_codes = []
    @event.subdivisions.each {|sub| vacc_codes << sub.code.upcase}
    render text: "No joy! Your access token does not match the event vaccs" and return unless vacc_codes.include? @key.vacc_code.upcase

    @event.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end

end
