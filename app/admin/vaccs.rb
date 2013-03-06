ActiveAdmin.register Vacc do
  menu :parent => "Reference", :priority => 5

  filter :country
  filter :vacc
  
  index do    
    column :country
    column :vacc
  end
  
end
