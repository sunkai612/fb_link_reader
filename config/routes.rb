Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root 'welcome#index'

  # get 'links/news', to: 'links#news'
  # get 'links/collection', to: 'links#collection'

  get "subscribed", to: "subscribed#index"
  get "subscribed/load_likes", to: "subscribed#load_likes"
  get "subscribed/reload", to: "subscribed#reload"
  post "subscribed/create", to: "subscribed#create"
  post "subscribed/destroy", to: "subscribed#destroy"

  get "collections", to: "collections#index"
  post "collections/mark_as_read", to: "collections#mark_as_read"
  post "collections/destroy", to: "collections#destroy"

  sharings_get_actions = ["load","subscribed","pages","people","readed"]
  sharings_post_actions = ["next","mark_as_read","save_to_collection"]

  sharings_get_actions.each do |sharing_get_action|
    get "sharings/#{sharing_get_action}", to: "sharings##{sharing_get_action}"
  end

  sharings_post_actions.each do |sharing_post_action|
    post "sharings/#{sharing_post_action}", to: "sharings##{sharing_post_action}"
  end

  # get :links do
  #   collection do
  #     get 'load'
  #     get 'subscription'
  #     get 'pages'
  #     get 'people'
  #     get 'next'
  #     get 'mark_as_read'
  #     get 'save_to_collection'
  #     get 'destroy'
  #   end
  # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
