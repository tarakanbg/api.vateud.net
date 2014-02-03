Vaccs::Application.routes.draw do

  mount Rich::Engine => '/rich', :as => 'rich'

  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get 'members/validate' => 'members#validate'
  get 'members/id/:id' => 'members#single'
  resources :members, :only => [:index, :show]
  resources :countries, :only => [:index, :show]
  get 'airports/country/:id' => 'airports#country'
  resources :airports, :only => [:index, :show]
  resources :ratings, :only => [:index, :show]
  resources :emails, :only => [:show]
  resources :subdivisions, :only => [:index, :show]
  get 'events/vacc/:id' => 'events#vacc'
  resources :events
  get 'staff_members/vacc/:id' => 'staff_members#vacc'
  resources :staff_members
  resources :frequencies, :only => [:index, :show]
  resources :squawks, :only => [:index]
  get 'online' => 'online#index'
  get 'online/search' => 'online#search'
  get 'online/search_callsign' => 'online#search_callsign'
  get 'online/atc/:id' => 'online#atc'
  get 'online/callsign/:id' => 'online#callsign'
  get 'online/pilots/:id' => 'online#pilots'
  get 'online/arrivals/:id' => 'online#arrivals'
  get 'online/departures/:id' => 'online#departures'
  get 'notams' => 'notams#index'
  get 'notams/search' => 'notams#search'
  get 'notams/:id' => 'notams#show'
  get 'charts' => 'charts#index'
  get 'charts/search' => 'charts#search'
  get 'charts/:id' => 'charts#show'

  root :to => 'online#help'

end
