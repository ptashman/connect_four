Rails.application.routes.draw do
  resources :discs, only: [:index] do
    delete :index, on: :collection, action: :delete_all
  end
  resources :players, only: [:index]
  root to: 'players#index'
  post 'players/move', :to => 'players#move'
end
