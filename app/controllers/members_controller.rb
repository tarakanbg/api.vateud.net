class MembersController < ApplicationController
  
  caches_action :index, expires_in: 3.hours
  caches_action :show, expires_in: 4.hours

  def index
    @members = Member.select("cid, firstname, lastname, rating, pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @members }
      format.xml { render xml: @members.to_xml(skip_types: true) }
      format.csv { send_data @members.to_csv }
    end
  end

  
  def show
    @members = Member.where(["subdivision = ?", params[:id]]).select("cid, firstname, lastname, rating, pilot_rating, country, subdivision, reg_date").reorder("reg_date DESC")

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @members }
      format.xml { render xml: @members.to_xml(skip_types: true) }
      format.csv { send_data @members.to_csv }
    end
  end

  
end
