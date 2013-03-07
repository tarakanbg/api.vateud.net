ActiveAdmin.register Subdivision do
  menu :parent => "Edit", :priority => 4
  actions :all, :except => [:destroy]

  filter :code
  filter :name
  filter :website
  filter :introtext
  
  
  index do    
    column :code
    column "Name" do |subdivision|
      link_to subdivision.name, admin_subdivision_path(subdivision)
    end
    column :website
    column :introtext
    
    default_actions    
  end

  form do |f|
    f.inputs "Details" do
      f.input :code
      f.input :name
      f.input :website
      f.input :introtext
    end
    
    f.buttons
  end

  show do |vacc|
    # h3 vacc.name
    attributes_table do
      row :code
      # row :name
      row :website
      row :introtext        
    end

    h3 "Staff members:"
    div do      
      panel("Staff members") do
        table_for(vacc.staff) do
          column "Callsign" do |i| 
            link_to(i.callsign, admin_staff_path(i))
          end
          column :name
          column :cid
          column :callsign
          column :Email
          column :position  
          column "Actions" do |i| 
            link_to("Edit", edit_admin_staff_path(i))
          end        
        end
      end
    end
  end
  
end
