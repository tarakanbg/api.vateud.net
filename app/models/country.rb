class Country < ActiveRecord::Base
  attr_accessible :code, :name, :subdivision_id, :eud
  belongs_to :subdivision, :inverse_of => :countries

  validates :code, :name, :presence => true

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
