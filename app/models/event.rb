class Event < ActiveRecord::Base
  attr_accessible :airports, :banner_url, :description, :ends, :starts, :subtitle, :title, :subdivision_ids
  has_paper_trail
  has_and_belongs_to_many :subdivisions
  validates :title, :description, :starts, :ends, :subtitle, :airports, :presence => true

  rails_admin do 
    navigation_label 'vACC Staff Zone'
  end
end
