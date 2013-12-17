class StaffMembersController < ApplicationController
  before_filter :restrict_access, :only => [:create, :update, :destroy] 

  caches_action :index, :cache_path => Proc.new { |c| c.params }, expires_in: 5.minutes
  caches_action :show, :cache_path => Proc.new { |c| c.params }, expires_in: 5.minutes
  caches_action :vacc, :cache_path => Proc.new { |c| c.params }, expires_in: 5.minutes

  def index
    @pagetitle = "vACC Staff Members"
    @staff_members = StaffMember.all
    @search = StaffMember.search(params[:q])
    @search.sorts = 'vacc_code ASC' if @search.sorts.empty?
    @staff_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
    @json = @staff_members.to_json(:except => [:created_at, :updated_at], :include => { :subdivision => {
                                               :only => [:code, :name] }, :member => {:only => [:firstname, :lastname,
                                               :humanized_atc_rating, :country]} })
    @xml = @staff_members.to_xml(:except => [:created_at, :updated_at], :include => { :subdivision => {
                                               :only => [:code, :name] }, :member => {:only => [:firstname, :lastname,
                                               :humanized_atc_rating, :country]} })

    respond_to do |format|
      format.html
      format.json { render json: @json }
      format.xml { render xml: @xml }
      format.csv { send_data StaffMember.to_csv }
    end
  end

  
  def show
    @pagetitle = "Staff Member Details"
    if @staff_member = StaffMember.find(params[:id])
      @json = @staff_member.to_json(:except => [:created_at, :updated_at], :include => { :subdivision => {
                                                 :only => [:code, :name] }, :member => {:only => [:firstname, :lastname,
                                                 :humanized_atc_rating, :country]} })
      @xml = @staff_member.to_xml(:except => [:created_at, :updated_at], :include => { :subdivision => {
                                                 :only => [:code, :name] }, :member => {:only => [:firstname, :lastname,
                                                 :humanized_atc_rating, :country]} })
    end
    rescue ActiveRecord::RecordNotFound
      render :text => "Staff member not in database" and return  

    respond_to do |format|
      if @staff_member
        format.html
        format.json { render json: @json }
        format.xml { render xml: @xml }
        format.csv { send_data @staff_member.to_csv_single }
      else
        format.any { render :text => "Staff member not in database" }
      end
    end
  end

  def vacc
    @code = params[:id].upcase
    if @vacc = Subdivision.find_by_code(@code)
      @pagetitle = "Staff members for #{@vacc.name}"
      @staff_members = @vacc.staff_members.reorder("priority ASC")
      @search = @staff_members.search(params[:q])
      @search.sorts = 'priority asc' if @search.sorts.empty?
      @staff_html = @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 20)
      @json = @staff_members.to_json(:except => [:created_at, :updated_at], :include => { :subdivision => {
                                                 :only => [:code, :name] }, :member => {:only => [:firstname, :lastname,
                                                 :humanized_atc_rating, :country]} })
      @xml = @staff_members.to_xml(:except => [:created_at, :updated_at], :include => { :subdivision => {
                                                 :only => [:code, :name] }, :member => {:only => [:firstname, :lastname,
                                                 :humanized_atc_rating, :country]} })
    end

    respond_to do |format|
      if @vacc
        format.html
        format.json { render json: @json }
        format.xml { render xml: @xml }
        format.csv { send_data @staff_members.to_csv }
      else
        format.any { render :text => "Subdivision not in database" }
      end
    end    
  end

  def create
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end

    @staff_member = StaffMember.new(params[:staff_member])
    @staff_member.vacc_code = @key.vacc_code.upcase
    if @staff_member.save      
      respond_to do |format|
        format.json{render :json => @staff_member, :status => :created }
      end
    else
      format.json { render json: @staff_member.errors, status: :unprocessable_entity }
    end
  end

  def update
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end

    @staff_member = StaffMember.find(params[:id])
    vacc_code = @staff_member.vacc_code    
    render text: "No joy! Your access token does not match the staff member's vaccs" and return unless vacc_code == @key.vacc_code.upcase
    respond_to do |format|
      if @staff_member.update_attributes(params[:staff_member])        
        format.json { render :json => @staff_member, :status => :updated }
      else        
        format.json { render json: @staff_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authenticate_or_request_with_http_token do |token, options|
      @key = ApiKey.find_by_access_token(token)
    end

    @staff_member = StaffMember.find(params[:id])
    vacc_code = @staff_member.vacc_code
    render text: "No joy! Your access token does not match the staff member's vaccs" and return unless vacc_code == @key.vacc_code.upcase
    
    @staff_member.destroy

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
