class StaffMember < ActiveRecord::Base
  attr_accessible :callsign, :cid, :email, :position, :priority, :vacc_code #, :vateud_confirmed

  attr_accessor :name
  attr_accessor :member

  default_scope order('priority ASC')

  belongs_to :subdivision, :primary_key => 'code', :foreign_key => 'vacc_code'

  has_paper_trail

  validates :callsign, :position, :vacc_code, :priority, :presence => true

  after_update :mark_unconfirmed  

  def name
    if self.member
        self.member.firstname + " " + self.member.lastname
    else
      "VACANT"
    end
  end

  def member
    Member.find_by_cid(self.cid)
  end

  def mark_unconfirmed
    if self.vateud_confirmed?
      unless self.vateud_confirmed_changed?
        self.vateud_confirmed = false   
        self.save   
      end 
    end
  end

  def approve_staff_member
    self.vateud_confirmed = true
    self.save
  end

  # def self.import_old_staff
  #   old = Staff.all
  #   old.each do |o|
  #     StaffMember.create(cid: o.cid, callsign: o.callsign, vacc_code: o.vacc_code, email: o.Email,
  #                        position: o.position, priority: o.list_order)
  #   end
  # end

  def self.to_csv(options = {})
    columns = ["vacc_code", "callsign", "position", "cid", "email", "priority"]
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |staff_member|
        csv << staff_member.attributes.values_at(*columns)
      end
    end
  end

  def to_csv_single(options = {})
    columns = ["vacc_code", "callsign", "position", "cid", "email", "priority"]
    CSV.generate(options) do |csv|
      csv << columns
      csv << self.attributes.values_at(*columns)
    end
    rescue ActiveModel::MissingAttributeError
      columns = ["vacc_code", "callsign", "position", "cid", "email", "priority"]
      CSV.generate(options) do |csv|
        csv << columns
        csv << self.attributes.values_at(*columns)
      end
  end

  rails_admin do 
    navigation_label 'vACC Staff Zone'

    list do
      field :subdivision
      field :callsign do        
        pretty_value do          
          id = bindings[:object].id
          callsign = bindings[:object].callsign
          bindings[:view].link_to "#{callsign}", bindings[:view].rails_admin.show_path('staff_member', id)
        end
      end
      field :position do        
        pretty_value do          
          id = bindings[:object].id
          position = bindings[:object].position
          bindings[:view].link_to "#{position}", bindings[:view].rails_admin.show_path('staff_member', id)
        end
      end
      field :cid
      field :vateud_confirmed do
        read_only true
      end
      field :member do
        pretty_value do          
          id = bindings[:object].id
          if bindings[:object].member
            member = bindings[:object].member
            bindings[:view].link_to "#{member.firstname} #{member.lastname}", bindings[:view].rails_admin.show_path('member', member.id)
          end
        end
      end
    end

    edit do     
      field :subdivision
      field :callsign
      field :position
      field :cid
      field :email
      field :priority    
    end
    
  end
end
