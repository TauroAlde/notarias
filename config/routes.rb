Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    delete "logout/:id", to: "devise/sessions#destroy", as: :logout
  end
  ActiveAdmin.routes(self)
  
  authenticated :user, ->(u) { u.only_common? } do
    root "prep_processes#new"
  end

  root 'dashboards#index'

  resources :users, except: [:index]

  resources :dashboards
  resources :task_catalogs
  resources :procedure_catalogs
  resources :user_preferences

  resources :segments, only: [:show] do
    get :jstree_segment, on: :collection
    get :jstree_search, on: :collection
    resources :users_imports, only: [:new, :update]
    resources :prep_step_fours, only: [:update] # we need the segment to load the candidacies
    resources :representative_assignations, only: [:new, :update, :destroy]

    resources :prep_processes do
      post :next, on: :member # :collection doesn't require resource id "on: :collection"
      get :complete, on: :member
    end
    resources :segment_messages, only: [:create] do
      post :evidence, on: :collection
    end
    resources :users do
      post :lock, on: :member # requires id of the resource "on: :member"
      post :unlock, on: :member
    end
  end

  resources :segment_messages, only: [:index, :show]

  resources :transfer_users, only: [:new, :create] do
    get :select, on: :collection
    get :jstree_segment, on: :collection
  end

  resources :prep_step_threes, only: [:update]
  resources :prep_step_twos, only: [:update]
  resources :profiles, only: [:edit, :update]

  resources :prep_processes, only: [:new]

  post 'users_batch_action', to: 'users_batch_actions#create'

  # handles /
  get '', to: redirect("/#{I18n.locale}")
end
