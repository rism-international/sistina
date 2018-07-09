Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :codes do
  resources :parts
    resources :pieces do 
      resources :concordances
    end
  end
end
