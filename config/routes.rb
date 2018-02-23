Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    delete "logout/:id", to: "devise/sessions#destroy", as: :logout
  end
  ActiveAdmin.routes(self)
  root 'dashboards#index' 

  resources :users, except: [:destroy] do
    post :lock, on: :member
    post :unlock, on: :member
  end
  resources :dashboards
  resources :task_catalogs
  resources :procedure_catalogs
  resources :user_preferences

  # handles /
  get '', to: redirect("/#{I18n.locale}")
end
