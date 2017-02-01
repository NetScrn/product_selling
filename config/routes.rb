Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  resources :products, except: [:edit, :update, :destroy]
  resources :sales, except: [:edit, :update, :destroy]
  scope 'reports', controller: :reports do
    get 'sales-per-product', action: :sales_per_product
    get 'sales-per-month', action: :sales_per_month
  end
end
