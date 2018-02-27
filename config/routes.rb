Rails.application.routes.draw do
  resources :spaces
  resources :discs do
    delete :index, on: :collection, action: :delete_all
  end
  resources :players
  root to: 'players#index'
  post 'players/move', :to => 'players#move'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
