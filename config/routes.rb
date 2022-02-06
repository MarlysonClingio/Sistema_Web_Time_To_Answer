Rails.application.routes.draw do
  namespace :site do
    get 'welcome/index'
  end
  namespace :admins_backoffice do
    get 'welcome/index' # Dashboards
    resources :admins # Administradores
    resources :subjects # Assuntos/Áreas
    resources :questions # Perguntas
  end
  namespace :users_backoffice do
    get 'welcome/index'
  end

  devise_for :admins
  devise_for :users
  
  root to: 'site/welcome#index'
end
