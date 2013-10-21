class Vacc < ActiveRecord::Base
  attr_accessible :country, :vacc
  has_paper_trail

  rails_admin do 
    navigation_label 'Reference'
  end
end
