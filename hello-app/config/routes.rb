Rails.application.routes.draw do
  resources :items
  get 'error', to: 'items#error'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
