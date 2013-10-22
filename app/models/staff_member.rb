class StaffMember < ActiveRecord::Base
  attr_accessible :callsign, :cid, :email, :position, :priority, :vacc_code, :vateud_confirmed

  attr_accessor :name

  default_scope order('priority ASC')

  has_one :member, :foreign_key => 'cid', :primary_key => 'cid'

  belongs_to :subdivision, :primary_key => 'code', :foreign_key => 'vacc_code'

  has_paper_trail

  validates :callsign, :position, :vacc_code, :priority, :presence => true

  def name
    if self.member
        self.member.firstname + " " + self.member.lastname
    else
      "VACANT"
    end
  end

  def self.import_old_staff
    old = Staff.all
    old.each do |o|
      StaffMember.create(cid: o.cid, callsign: o.callsign, vacc_code: o.vacc_code, email: o.Email,
                         position: o.position, priority: o.list_order)
    end
  end

  rails_admin do 
    navigation_label 'vACC Staff Zone'

    list do
      field :subdivision
      field :callsign
      field :position
      field :cid
      field :vateud_confirmed do
        read_only true
      end
      field :member
    end

    edit do
      field :subdivision
      field :callsign
      field :position
      field :cid
      field :email
      field :priority
      field :vateud_confirmed do
        read_only true
      end
      field :member

    end
  end
end
