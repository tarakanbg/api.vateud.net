ActiveAdmin.register ApiKey do
  menu :parent => "Reference", :priority => 3

  form do |f|
    f.inputs "Details" do
      f.input :vacc_code      
    end
    
    f.buttons
  end
  
end