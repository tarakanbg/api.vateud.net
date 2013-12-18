class AtcBooking < ActiveRecord::Base
  attr_accessible :admin_user_id, :controller, :ends, :eu_id, :position, :starts

  belongs_to :admin_user

  validates :controller, :admin_user_id, :starts, :ends, :position, :presence => true
  validates_length_of :position, :maximum => 11
  validates_length_of :controller, :maximum => 50

  after_create :create_vatbook_booking, on: :create

  def create_vatbook_booking
    url = "http://vatbook.euroutepro.com/atc/insert.asp?Local_URL=noredir&LOCAL_ID=#{self.id}&b_day=#{self.starts.strftime("%d")}&b_month=#{self.starts.strftime("%m")}&b_year=#{self.starts.strftime("%Y")}&Controller=#{self.controller.gsub(" ","%20")}&Position=#{self.position.strip}&sTime=#{self.starts.strftime("%H%M")}&eTime=#{self.ends.strftime("%H%M")}&T=0&E=0&voice=1&TEST=1"
    response = Curl::Easy.http_get(url).body_str
    self.update_attribute(:eu_id, response.split[2][6..1000])
  end

  rails_admin do 
    navigation_label 'vACC Staff Zone'
    
    edit do
      field :admin_user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
      field :controller do
        label "Controller Name and Surname"
      end
      field :position
      field :starts
      field :ends      
    end

  end

end
