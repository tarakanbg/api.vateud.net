ActiveAdmin.register Member do
  menu :parent => "Reference", :priority => 3

  filter :cid
  filter :firstname
  filter :lastname
  filter :rating
  filter :pilot_rating
  filter :email
  filter :country
  filter :reg_date
  filter :region
  filter :division
  filter :subdivision
  
  
  index do    
    column :cid
    column :firstname
    column :lastname
    column :pilot_rating
    column :rating
    column :email
    column :country
    column :reg_date
    column :region
    column :division
    column :subdivision   
        
  end
  
end
