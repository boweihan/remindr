Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get '/callback', to: 'pages#callback'
  get '/garbage', to: 'pages#garbage'
end
