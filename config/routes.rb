Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  resources :products, except: [:edit, :update, :destroy]
  resources :sales, except: [:edit, :update, :destroy]
end
