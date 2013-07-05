class SubdivisionsController < ApplicationController
  # GET /subdivisons
  # GET /subdivisons.json
  def index
    @subdivisions = Subdivision.reorder("code ASC")

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @subdivisons }
    end
  end

  # GET /subdivisons/1
  # GET /subdivisons/1.json
  def show
    @subdivison = Subdivision.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subdivison }
    end
  end

  # GET /subdivisons/new
  # GET /subdivisons/new.json
  def new
    @subdivison = Subdivision.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subdivison }
    end
  end

  # GET /subdivisons/1/edit
  def edit
    @subdivison = Subdivision.find(params[:id])
  end

  # POST /subdivisons
  # POST /subdivisons.json
  def create
    @subdivison = Subdivision.new(params[:subdivison])

    respond_to do |format|
      if @subdivison.save
        format.html { redirect_to @subdivison, notice: 'Subdivison was successfully created.' }
        format.json { render json: @subdivison, status: :created, location: @subdivison }
      else
        format.html { render action: "new" }
        format.json { render json: @subdivison.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subdivisons/1
  # PUT /subdivisons/1.json
  def update
    @subdivison = Subdivision.find(params[:id])

    respond_to do |format|
      if @subdivison.update_attributes(params[:subdivison])
        format.html { redirect_to @subdivison, notice: 'Subdivison was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subdivison.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subdivisons/1
  # DELETE /subdivisons/1.json
  def destroy
    @subdivison = Subdivision.find(params[:id])
    @subdivison.destroy

    respond_to do |format|
      format.html { redirect_to subdivisons_url }
      format.json { head :no_content }
    end
  end
end
