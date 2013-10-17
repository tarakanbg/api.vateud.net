class Event < ActiveRecord::Base
  attr_accessible :airports, :banner_url, :description, :ends, :starts, :subtitle, :title
  has_paper_trail
end
