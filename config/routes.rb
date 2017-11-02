Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root 'dashboards#index' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users
  resources :dashboards
  resources :task_catalogs
end
