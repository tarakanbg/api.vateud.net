class SubdivisionsController < ApplicationController

  caches_action :index, expires_in: 3.hours
  
  def index
    @pagetitle = "vACC Codes"
    @search = Subdivision.reorder("code ASC").search(params[:q])
    @search.sorts = 'code asc' if @search.sorts.empty?
    @subdivisions = @search.result(:distinct => true)

    respond_to do |format|
      format.html 
    end
  end

 
end