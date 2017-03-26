Rails.application.routes.draw do
  devise_for :users
  resources :articles do
    resources :comments, only: [:create, :destroy]
  end

  get 'users', to: 'users_stat#index'
  get '/users/:id', to: 'users_stat#show', as: 'user'

  root 'articles#index'
end
