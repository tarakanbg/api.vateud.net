class SquawksController < ApplicationController

  caches_action :index, :cache_path => Proc.new { |c| c.params }, expires_in: 4.hours
  caches_action :show, :cache_path => Proc.new { |c| c.params }, expires_in: 4.hours

  def index
    @pagetitle = "VATEUD approved squawk ranges"
    #@squawks = Squawk.active
    @search = Squawk.active.search(params[:q])
    @search.sorts = 'facility asc' if @search.sorts.empty?
    @squawks = @search.result(:distinct => true)
    respond_to do |format|
      format.html
      format.json { render json: scope_json(@squawks) }
      format.xml { render xml: scope_xml(@squawks) }
      format.csv { send_data Squawk.to_csv }
    end
  end

private

  def scope_json(freqs)
    freqs.to_json(:only => [:facility, :position, :start, :end])
  end

  def scope_xml(freqs)
    freqs.to_xml(:only =>  [:facility, :position, :start, :end], skip_types: true)
  end

end
