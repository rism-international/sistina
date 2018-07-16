Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :codes 
  resources :parts
  resources :pieces 
  resources :concordances
  resources :units
end
