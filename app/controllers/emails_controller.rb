class EmailsController < ApplicationController
  before_filter :restrict_access  
  
  def show
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end
    vacc_code = params[:id].downcase
    render text: "No joy! Your access token does not match the requested vacc" and return if vacc_code != @key.vacc_code.downcase

    @members = Member.where(["subdivision = ?", params[:id].upcase]).select("cid, firstname, lastname, email, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date, susp_ends").reorder("reg_date DESC")

    respond_to do |format|
      format.html { render text: "No joy! Specify json, xml or csv extension" }
      format.json { render json: @members }
      format.xml { render xml: @members.to_xml(skip_types: true) }
      format.csv { send_data @members.to_csv_with_emails }
    end
  end

private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end 

end
