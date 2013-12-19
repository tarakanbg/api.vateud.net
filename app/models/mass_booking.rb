class MassBooking < ActiveRecord::Base
  attr_accessible :admin_user_id, :csv_file

  has_attached_file :csv_file

  belongs_to :admin_user

  validates :admin_user_id, :csv_file, :presence => true

  has_paper_trail

  after_create :process_csv_bookings

  def process_csv_bookings
    CSV.foreach(self.csv_file.queued_for_write[:original].path, encoding: "utf-8:utf-8") do |row| 
      AtcBooking.create(controller: row[0], position: row[1], starts: row[2], ends: row[3], admin_user_id: self.admin_user_id)
    end
  end

  rails_admin do 
    navigation_label 'Events and bookings'
    
    edit do
      field :admin_user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end

      field :csv_file  do
        label "CSV file (UTF encoded)"
      end
         
    end

  end  
end
