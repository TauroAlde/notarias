Rails.application.routes.draw do
  scope "/:locale", defaults: { locale: 'es' } do
    devise_for :users
    ActiveAdmin.routes(self)
    root 'dashboards#index' 
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    resources :users
    resources :dashboards
  end

  get '/*path', to: redirect("/#{I18n.default_locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }

  # handles /
  get '', to: redirect("/#{I18n.locale}")
end
