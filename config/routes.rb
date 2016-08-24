Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'pages#landing'
  get '/pull_messages' => 'pages#pull_messages'
  get '/link_to_twitter' => 'pages#twitter_sync'
  # get '/tweet_info' => 'pages#tweet_info'
  get '/auth/twitter/callback' => 'pages#twitter_callback'
  get '/googleauth' => 'pages#googleauth'
  get '/callback'=> 'pages#callback'
  post '/send' => 'messages#send_mail'
  get 'newsfeed' => 'pages#newsfeed'
  # get '/analytics' => 'pages#analytics'
  post '/direct_messages' => 'messages#create_direct_message'
  post '/tweets' => 'messages#create_tweet'
  get '/reminders' => 'reminders#index'
  get '/import_contacts' => "pages#import"
  get '/permission' => "pages#permission"
  resources :users, only: [:create, :update,:show]

  resources :contacts, only: [:show, :create, :destroy, :update, :index, :edit]
  # do
  #   resources :reminders, only: [:index, :show, :create, :new, :update, :destroy]
  # end

  resources :sessions, only: [:create, :destroy]

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
