Redbook::Application.routes.draw do

  resources :positions


  resources :invitations


  match "api" => "home#api"
  match "lip" => "home#lip"
  match "what" => "home#what"
  match "help" => "home#help"
  match "about" => "home#about"
  match "terms" => "home#terms"
  match "privacy" => "home#privacy"
  match "cookie" => "home#cookie"
  # match "dashboard" => "home#dashboard"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :presses
  resources :blogs
  resources :projects

  authenticated :user do
    # root :to => 'home#dashboard'
  end
  root :to => "home#index"
  devise_for :users
  match ":group_id/edit" => "groups#edit"
  resources :users
  # match "users/edit/positions" => "users#edit_positions"
  

  get "admin/list"
  match "admin/zombie2user/:id" => "admin#zombie2user"
  match "admin/user2zombie/:id" => "admin#user2zombie"
  
  #Group Routing
  match "universities" => "groups#universities"
  match "groups/sub/:id" => "groups#sub"
  match "groups/parent/:id" => "groups#parent"
  match "groups/addsub/:id/:sid" => "groups#addsub"
  match "groups/addpar/:id/:pid" => "groups#addpar"
  match "groups/rmsub/:id/:sid" => "groups#rmsub"
  match "groups/rmpar/:id/:pid" => "groups#rmpar"
  match "labs" => "groups#labs"
  match "companies" => "groups#companies"
  match "groups/user2mod/:id/:user_id" => "groups#user2mod"
  match "groups/mod2user/:id/:user_id" => "groups#mod2user"
  match "groups/mem/:id" => "groups#mem"
  match "groups/adduser/:id/:uid" => "groups#adduser"
  match "groups/rmuser/:id/:uid" => "groups#rmuser"
  match "groups/lvuser/:id/:uid" => "groups#lvuser"

  match ":group_id/about" => "groups#about"
  match ":group_id/member" => "groups#member"
  match ":group_id/activity" => "groups#activity"
  match ":group_id/relations" => "groups#relations"
  match ":group_id/memberships" => "groups#memberships"
  
  
  resources :groups



  get 'messages/autocomplete_user_firstname'

  resources :messages
  resources :users do
    resources :messages
    # get :autocomplete_user_firstname, :on => :collection
  end
end