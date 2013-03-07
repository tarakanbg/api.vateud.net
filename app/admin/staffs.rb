ActiveAdmin.register Staff do
  menu :parent => "Edit", :priority => 3, :label => "Staff"
  
  filter :vacc_code
  filter :callsign
  filter :cid
  filter :Email
  filter :position
  
  
  index do    
    column :subdivision
    column :callsign
    column :cid
    column :name
    column :Email
    column :position
    column :list_order
    
    default_actions
        
  end

  form do |f|
    f.inputs "Details" do
      f.input :vacc_code, :as => :select, :collection => Subdivision.all, :include_blank => true, :label_method => :name, :member_value => :code
      f.input :callsign
      f.input :cid
      f.input :Email
      f.input :position
      f.input :list_order
    end
    
    f.buttons
  end

  show do |staff|
    attributes_table do
      row :subdivision
      row :callsign
      row :cid
      # row :name
      row :Email
      row :position
    end
    
  end

end
