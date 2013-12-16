class Option < ActiveRecord::Base
  attr_accessible :key, :value
  validates :key, :value, :presence => true

  has_paper_trail
end
