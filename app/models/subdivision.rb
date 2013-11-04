class Subdivision < ActiveRecord::Base
  attr_accessible :code, :introtext, :name, :website, :hidden, :official, :country_ids, :frequency_countries
  attr_accessor :frequencies
  has_paper_trail
  default_scope order('name ASC')
  has_many :staff, :foreign_key => 'vacc_code', :primary_key => "code"
  has_many :admin_users
  has_many :countries, :inverse_of => :subdivision
  has_and_belongs_to_many :events
  has_many :staff_members, :primary_key => 'code', :foreign_key => 'vacc_code'
  has_one :custom_chart_source

  validates :code, :name, :website, :introtext, :presence => true

  scope :active, where(:hidden => false)
  scope :official, where(:official => true)

  # def self.import_old_subdivisions
  #   old = OldSubdivision.all
  #   old.each do |o|
  #     Subdivision.create(code: o.code, name: o.name, introtext: o.introtext, website: o.website)
  #   end
  # end

  def frequencies
    ids = self.frequency_countries.split(",").map { |s| s.to_i }
    Frequency.where("country IN (?)", ids)
  end

  rails_admin do 
    navigation_label 'vACC Staff Zone'

    list do
      field :code do        
        pretty_value do          
          id = bindings[:object].id
          code = bindings[:object].code
          bindings[:view].link_to "#{code}", bindings[:view].rails_admin.show_path('subdivision', id)
        end
      end
      field :name do        
        pretty_value do          
          id = bindings[:object].id
          name = bindings[:object].name
          bindings[:view].link_to "#{name}", bindings[:view].rails_admin.show_path('subdivision', id)
        end
      end
      field :official
      field :hidden
      field :countries
    end

    edit do
      field :code do
        read_only true
      end
      field :name
      field :website
      field :introtext, :rich_editor do
        config({
          :insert_many => true
        })
      end
      field :hidden
      field :official
      field :countries do
        associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          subdivision = bindings[:object]
          Proc.new { |scope|
            # scoping all Players currently, let's limit them to the team's league
            # Be sure to limit if there are a lot of Players and order them by position
            scope = scope.unscoped.where(eud: true).reorder('name ASC')
            # scope = scope.limit(30)
          }
        end
      end    
      field :frequency_countries
    end
  end
end
