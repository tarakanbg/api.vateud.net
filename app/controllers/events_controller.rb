class EventsController < ApplicationController
  def index
    @pagetitle = "Events Calendar"
    # @events = Event.select("title, subtitle, airports, banner_url, description, starts, ends").reorder("starts DESC")
    @events = Event.reorder("starts DESC")
    @search = Event.search(params[:q])
    @search.sorts = 'starts desc' if @search.sorts.empty?
    @events_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
    @json = @events.to_json(:except => [:created_at, :updated_at], :include => { :subdivisions => {
                                               :only => [:code, :name] } })
    @xml = @events.to_xml(:except => [:created_at, :updated_at], :include => { :subdivisions => {
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
    @event = Event.find(params[:id])

    @json = @event.to_json(:except => [:created_at, :updated_at], :include => { :subdivisions => {
                                               :only => [:code, :name] } })
    @xml = @event.to_xml(:except => [:created_at, :updated_at], :include => { :subdivisions => {
                                               :only => [:code, :name] } }, skip_types: true)

    respond_to do |format|
      format.html
      format.json { render json: @json }
      format.xml { render xml: @xml }
      format.csv { send_data @event.to_csv_single }
      format.ics { send_data Event.calendar_single(@event) }
    end
  end

  def vacc
    @code = params[:id].upcase
    @vacc = Subdivision.find_by_code(@code)
    @pagetitle = "Events for #{@vacc.name}"
    @events = @vacc.events
    @search = @events.search(params[:q])
    @search.sorts = 'starts desc' if @search.sorts.empty?
    @events_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
    @json = @events.to_json(:except => [:created_at, :updated_at], :include => { :subdivisions => {
                                               :only => [:code, :name] } })
    @xml = @events.to_xml(:except => [:created_at, :updated_at], :include => { :subdivisions => {
                                               :only => [:code, :name] } }, skip_types: true)

    respond_to do |format|
      format.html
      format.json { render json: @json }
      format.xml { render xml: @xml }
      format.csv { send_data @events.to_csv }
      format.ics { send_data Event.calendar(@events) }
    end    
  end

  def create
    @event = Event.new(params[:event])
    if @event.save      
      respond_to do |format|
        format.json{render :json => @event, :status => :created }
      end
    end
  end

  
end
