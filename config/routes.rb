Rails.application.routes.draw do
  devise_for :users
  # get 'welcome/index'

  # get "auth/:provider/callback", to: "sessions#create"
  # resources :welcome

  get 'welcome/launch'
  post 'welcome/launch'

  # root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
