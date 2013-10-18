class Subdivision < ActiveRecord::Base
  attr_accessible :code, :introtext, :name, :website
  has_paper_trail
  default_scope order('name ASC')
  has_many :staff, :foreign_key => 'vacc_code', :primary_key => "code"
  has_many :admin_users
  has_and_belongs_to_many :events

  def self.import_old_subdivisions
    old = OldSubdivision.all
    old.each do |o|
      Subdivision.create(code: o.code, name: o.name, introtext: o.introtext, website: o.website)
    end
  end

  rails_admin do 
    navigation_label 'vACC Staff Zone'
  end
end
