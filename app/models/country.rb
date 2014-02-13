class Country < ActiveRecord::Base
  attr_accessible :code, :name, :subdivision_id, :eud, :frequency_country_id
  attr_accessor :frequencies
  belongs_to :subdivision, :inverse_of => :countries
  belongs_to :frequency_country, :inverse_of => :country
  has_many :airports

  validates :code, :name, :presence => true

  def frequencies
    self.frequency_country.frequencies
  end

  # default_scope order('name DESC')

  rails_admin do
    navigation_label 'API management'

    list do
      field :id do
        column_width 40
      end
      field :code
      field :name do
        column_width 220
        pretty_value do
          id = bindings[:object].id
          name = bindings[:object].name
          bindings[:view].link_to "#{name}", bindings[:view].rails_admin.show_path('country', id)
        end
      end
      field :subdivision
      field :eud
    end

    edit do
      field :code do
        read_only true
      end
      field :name
      field :eud
      field :subdivision
    end
  end

end
