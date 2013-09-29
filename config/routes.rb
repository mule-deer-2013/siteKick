MizeCraft::Application.routes.draw do

  root to: 'pages#new'
  resources :pages, only: [:new, :show, :create, :index]
  
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  resources :users
  resources :sessions

end