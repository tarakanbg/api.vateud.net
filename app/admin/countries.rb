ActiveAdmin.register Country do
  menu :parent => "Reference", :priority => 4

  filter :code
  filter :name
  
  index do    
    column :code
    column :name
  end
  
end
