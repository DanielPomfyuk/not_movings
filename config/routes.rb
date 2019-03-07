Rails.application.routes.draw do
  # devise_for :users
  get "404", to: "errors#error_404"
  get "/422", to: "errors#error_422"
  get "/500", to: "errors#error_500"
  root 'users#index'
  get 'users/show'
  get 'users/edit'
  resources :users
end
