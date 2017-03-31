Rails.application.routes.draw do
  devise_for :users
  resources :articles do
    resources :comments, only: [:create, :destroy]
  end

  get 'users', to: 'users_stat#index'
  get '/users/:id', to: 'users_stat#show', as: 'user'
  match '/users/:id', to: 'users_stat#destroy', as: 'user_delete', via: :delete

  root 'articles#index'
end
