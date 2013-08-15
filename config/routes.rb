Vaccs::Application.routes.draw do

  resources :members, :only => [:index, :show]
  # resources :charts, :only => [:index, :show]
  resources :countries, :only => [:index, :show]
  resources :ratings, :only => [:index, :show]
  resources :emails, :only => [:show]
  resources :subdivisions, :only => [:index]
  # get 'online/:id' => 'online#index'
  get 'online' => 'online#index'
  get 'online/search' => 'online#search'
  get 'online/atc/:id' => 'online#atc'
  get 'online/pilots/:id' => 'online#pilots'
  get 'online/arrivals/:id' => 'online#arrivals'
  get 'online/departures/:id' => 'online#departures'
  get 'notams' => 'notams#index'
  get 'notams/search' => 'notams#search'
  get 'notams/:id' => 'notams#show'
  get 'charts' => 'charts#index'
  get 'charts/search' => 'charts#search'
  get 'charts/:id' => 'charts#show'


  devise_for :admin_users, ActiveAdmin::Devise.config
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'admin/subdivisions#index'
  root :to => 'online#help'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  ActiveAdmin.routes(self)
end
