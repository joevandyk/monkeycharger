ActionController::Routing::Routes.draw do |map|
   map.resources :credit_cards 
   map.authorize '/authorizations', :controller => 'authorizations', :action => 'create'
end
