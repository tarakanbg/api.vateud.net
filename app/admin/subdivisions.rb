ActiveAdmin.register Subdivision do
  menu :parent => "Edit", :priority => 4
  actions :all, :except => [:destroy]

  filter :code
  filter :name
  filter :website
  filter :introtext
  
  
  index do    
    column :code
    column :name
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
  
end
