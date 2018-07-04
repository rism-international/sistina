Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :codes do
    resources :pieces do 
#      resources :parts
      resources :concordances
    end
  end
end
