Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/discover', to: 'discover#index'
  get '/dashboard', to: 'dashboard#show'
  delete '/logout', to: 'sessions#destroy'

  resources :movies, only: %i[index show] do
    get '/viewing-party/new', to: 'viewing_party#new'
    post '/viewing-party', to: 'viewing_party#create'
  end
end
