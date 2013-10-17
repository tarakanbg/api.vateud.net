class Vacc < ActiveRecord::Base
  attr_accessible :country, :vacc
  has_paper_trail
end
