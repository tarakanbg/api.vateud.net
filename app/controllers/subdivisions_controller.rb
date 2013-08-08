class SubdivisionsController < ApplicationController

  caches_action :index, expires_in: 3.hours
  
  def index
    # @subdivisions = Subdivision.reorder("code ASC")
    @pagetitle = "vACC Codes"
    @search = Subdivision.reorder("code ASC").search(params[:q])
    @search.sorts = 'code asc' if @search.sorts.empty?
    @subdivisions = @search.result(:distinct => true)

    respond_to do |format|
      format.html 
    end
  end

  
  # def show
  #   @subdivison = Subdivision.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @subdivison }
  #   end
  # end

  
end
