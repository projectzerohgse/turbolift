Rails.application.routes.draw do
  # get 'welcome/index'
  root to: "welcome#index"

  # get "auth/:provider/callback", to: "sessions#create"
  resources :welcome

  # root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
