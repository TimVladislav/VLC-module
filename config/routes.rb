Rails.application.routes.draw do
  resources :startpage, only: [:index]
  resources :devices, only: [:index, :new, :show, :destroy, :create]
  resources :labs do
    get  :code, on: :member
    post :codewrite
    post :export
    post :butt_send, on: :member
  end
  root "startpage#index"

  get '/builder', :to => 'devices#builder_new'
  get '/builder/:id', :to => 'devices#builder_index'
  get '/builder/:id/success', :to => 'devices#builder_success'
  post '/builder/:id/addbutton', :to => 'devices#builder_new_button'
  post '/device/builder/new' => 'devices#builder_create'
  post '/builder/:id/resize', :to => 'devices#builder_button'

  get '/test/json', :to => 'devices#test_json'
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
