Rails.application.routes.draw do
  devise_for :users
  # get 'survey/index'

  # get "auth/:provider/callback", to: "sessions#create"
  # resources :survey

  get 'survey/launch'
  post 'survey/launch'

  get 'survey/complete'

  # root 'survey#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
