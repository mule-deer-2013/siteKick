MizeCraft::Application.routes.draw do

  root to: 'static_pages#index'
  resources :static_pages, only: [:show, :index]
  resources :pages, only: [:new, :show, :create, :index]
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

end