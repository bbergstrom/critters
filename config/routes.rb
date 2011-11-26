Critters::Application.routes.draw do

  resources :critters

  match 'user/edit' => 'users#edit', :as => :edit_current_user

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login

  resources :sessions

  resources :users

  match '/about' => 'pages#about'
  root :to => 'pages#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
#== Route Map
# Generated on 25 Nov 2011 23:03
#
#                   POST   /critters(.:format)          {:action=>"create", :controller=>"critters"}
#       new_critter GET    /critters/new(.:format)      {:action=>"new", :controller=>"critters"}
#      edit_critter GET    /critters/:id/edit(.:format) {:action=>"edit", :controller=>"critters"}
#           critter GET    /critters/:id(.:format)      {:action=>"show", :controller=>"critters"}
#                   PUT    /critters/:id(.:format)      {:action=>"update", :controller=>"critters"}
#                   DELETE /critters/:id(.:format)      {:action=>"destroy", :controller=>"critters"}
# edit_current_user        /user/edit(.:format)         {:action=>"edit", :controller=>"users"}
#            signup        /signup(.:format)            {:action=>"new", :controller=>"users"}
#            logout        /logout(.:format)            {:action=>"destroy", :controller=>"sessions"}
#             login        /login(.:format)             {:action=>"new", :controller=>"sessions"}
#          sessions GET    /sessions(.:format)          {:action=>"index", :controller=>"sessions"}
#                   POST   /sessions(.:format)          {:action=>"create", :controller=>"sessions"}
#       new_session GET    /sessions/new(.:format)      {:action=>"new", :controller=>"sessions"}
#      edit_session GET    /sessions/:id/edit(.:format) {:action=>"edit", :controller=>"sessions"}
#           session GET    /sessions/:id(.:format)      {:action=>"show", :controller=>"sessions"}
#                   PUT    /sessions/:id(.:format)      {:action=>"update", :controller=>"sessions"}
#                   DELETE /sessions/:id(.:format)      {:action=>"destroy", :controller=>"sessions"}
#             users GET    /users(.:format)             {:action=>"index", :controller=>"users"}
#                   POST   /users(.:format)             {:action=>"create", :controller=>"users"}
#          new_user GET    /users/new(.:format)         {:action=>"new", :controller=>"users"}
#         edit_user GET    /users/:id/edit(.:format)    {:action=>"edit", :controller=>"users"}
#              user GET    /users/:id(.:format)         {:action=>"show", :controller=>"users"}
#                   PUT    /users/:id(.:format)         {:action=>"update", :controller=>"users"}
#                   DELETE /users/:id(.:format)         {:action=>"destroy", :controller=>"users"}
#             about        /about(.:format)             {:action=>"about", :controller=>"pages"}
#              root        /(.:format)                  {:action=>"home", :controller=>"pages"}
