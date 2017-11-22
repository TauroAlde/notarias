Rails.application.routes.draw do
  scope '/(:locale)', defaults: { locale: 'es' } do
    devise_for :users
    ActiveAdmin.routes(self)
    root 'dashboards#index' 

    resources :users
    resources :dashboards
  end
end
