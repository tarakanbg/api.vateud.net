ActiveAdmin.register Member do
  menu :parent => "Reference", :priority => 3

  filter :cid
  filter :firstname
  filter :lastname
  filter :rating
  filter :humanized_atc_rating
  filter :pilot_rating
  filter :humanized_pilot_rating
  filter :email
  filter :country
  filter :reg_date
  filter :region
  filter :division
  filter :subdivision
  
  
  index do      
    column :id
    column :cid
    column :firstname
    column :lastname
    column :rating
    column :humanized_atc_rating
    column :pilot_rating
    column :humanized_pilot_rating
    column :email
    column :country
    column :reg_date
    column :region
    column :division
    column :subdivision   
    
    actions  
  end
  
end
