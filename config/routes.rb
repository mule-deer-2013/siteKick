MizeCraft::Application.routes.draw do

  root to: 'pages#new'
  resources :pages, only: [:new, :show, :create, :index]

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

end