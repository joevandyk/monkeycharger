ActionController::Routing::Routes.draw do |map|
   map.resources :credit_cards 
   map.resources :voids
   map.resources :refunds
   map.resources :captures
   map.resources :authorizations
end
