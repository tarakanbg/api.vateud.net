class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :vatsimid, :subdivision_id,
                  :position, :roles, :admin, :roles_mask
  # attr_accessible :title, :body
  belongs_to :subdivision
  has_many :atc_bookings, :dependent => :destroy
  has_many :mass_bookings, :dependent => :destroy

  validates :email, :name, :vatsimid, :position, :presence => true

  has_paper_trail

  scope :admins, where(:admin => true)
  after_create :send_welcome_emails

  ROLES = %w[events staff]

  def send_welcome_emails
    admins = AdminUser.admins    
    emails = []
    admins.each {|u| emails << u.email}    
    MemberMailer.new_user_admins_email(self, emails).deliver if emails.count > 0
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  rails_admin do 
    navigation_label 'API management'  

    edit do
      field :name
      field :email
      field :password
      field :password_confirmation   
      field :vatsimid
      field :subdivision
      field :position   
      field :roles do
        def render          
          bindings[:view].render :partial => "roles_partial", :locals => {:admin_user => bindings[:object], :field => self, :form => bindings[:form]}
        end
      end
      field :admin
    end

    list do
      field :name do
        column_width 180
        pretty_value do          
          id = bindings[:object].id
          name = bindings[:object].name
          bindings[:view].link_to "#{name}", bindings[:view].rails_admin.show_path('admin_user', id)
        end
      end
      field :email
      field :created_at
      field :admin
    end
       
  end
end
