class MembersController < ApplicationController

  caches_action :index, :cache_path => Proc.new { |c| c.params }, expires_in: 3.hours
  caches_action :show, :cache_path => Proc.new { |c| c.params }, expires_in: 4.hours
  caches_action :single, expires_in: 2.hours

  def index
    @pagetitle = "Members list"
    @members = Member.select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating,
      humanized_pilot_rating, country, subdivision, reg_date, active").reorder("reg_date DESC")
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
    if @vacc = Subdivision.find_by_code(@code)
      @pagetitle = @vacc.name + " members"
      @members = Member.where(["subdivision = ?", @code]).select("cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date, active").reorder("reg_date DESC")

      @search = Member.where(["subdivision = ?", @code]).search(params[:q])
      @search.sorts = 'reg_date desc' if @search.sorts.empty?
      @members_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
    end

    respond_to do |format|
      if @vacc
        format.html
        format.json { render json: @members }
        format.xml { render xml: @members.to_xml(skip_types: true) }
        format.csv { send_data @members.to_csv }
      else
        format.any { render :text => "Subdivision not in database" }
      end
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
    auth = request.headers["Authorization"] if request.headers["Authorization"]
    if auth
      authenticate_or_request_with_http_token do |token, options|
        if ApiKey.exists?(access_token: token)
          @key = ApiKey.find_by_access_token(token)
        else
          @key = ApiKey.new(:vacc_code => "none")
        end
      end
      @member = Member.find_by_cid(@cid, :select => "cid, firstname, lastname, email, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date, susp_ends, active")
      if @member
        if @member.subdivision
          if @member.subdivision.downcase != @key.vacc_code.downcase
            @member = Member.find_by_cid(@cid, :select => "cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date, active")
          end
        end
      end
    else
      @member = Member.find_by_cid(@cid, :select => "cid, firstname, lastname, rating, humanized_atc_rating, pilot_rating, humanized_pilot_rating, country, subdivision, reg_date, active")
    end

    @member = member_from_cert(@cid) unless @member
    @pagetitle = "User details for #{@member.cid}" if @member
    @json = @member.to_json(:except => [:created_at, :updated_at, :age_band, :experience, :id, :state])
    @xml = @member.to_xml(:except => [:created_at, :updated_at, :age_band, :experience, :id, :state], skip_types: true)

    respond_to do |format|
      unless @member.reg_date.blank?
        format.html
        format.json { render json: @json }
        format.xml { render xml: @xml}
        format.csv { send_data @member.to_csv_single }
      else
        format.any { render :text => "Member not found" }
      end
    end
  end

private

  def member_from_cert(cid)
    xml_source = Nokogiri.XML(open("https://cert.vatsim.net/vatsimnet/idstatus.php?cid=#{cid}").read)
    sleep 1
    xml_source2 = Nokogiri.XML(open("https://cert.vatsim.net/vatsimnet/idstatusint.php?cid=#{cid}").read)
    if xml_source
      user = xml_source.css("user").children
      name_last = user.at('name_last').children.first.to_s
      rating = user.at('rating').children.first.to_s
      name_first = user.at('name_first').children.first.to_s
      regdate = user.at('regdate').children.first.to_s
      pilotrating = user.at('pilotrating').children.first.to_s
      country = user.at('country').children.first.to_s
      region = user.at('region').children.first.to_s
      division = user.at('division').children.first.to_s
    end
    if xml_source2
      user2 = xml_source.css("user").children
      rating_numeric = user2.at('rating').children.first.to_s
      pilotrating_numeric = user2.at('pilotrating').children.first.to_s
    end
    if xml_source && xml_source2
      member = Member.new(cid: cid, firstname: name_first, lastname: name_last, humanized_atc_rating: rating,
        rating: rating_numeric, pilot_rating: pilotrating_numeric,
        humanized_pilot_rating: pilotrating, reg_date: regdate, country: country, region: region, division: division)
    end
    member
  end

end
