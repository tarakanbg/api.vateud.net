ActiveAdmin.register Staff do
  menu :parent => "Edit", :priority => 3, :label => "Staff"
  
  filter :vacc_code
  filter :callsign
  filter :cid
  filter :Email
  filter :position
  
  
  index do    
    column :subdivision
    # column "VACC" do |staff|
    #   staff.subdivision.name if staff.subdivision
    # end
    column :callsign
    column :cid
    column "Name" do |staff|
      if staff.member
        staff.member.firstname + " " + staff.member.lastname
      end
    end
    column :Email
    column :position
    column :list_order
    
    default_actions
        
  end

  form do |f|
    f.inputs "Details" do
      # f.input :subdivision
      f.input :vacc_code, :as => :select, :collection => Subdivision.all, :include_blank => true, :label_method => :name, :member_value => :code
      f.input :callsign
      f.input :cid
      f.input :Email
      f.input :position
      f.input :list_order
    end
    
    f.buttons
  end

end
