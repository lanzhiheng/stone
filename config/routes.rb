Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/about', to: 'about#index', as: 'about'
  get '/contact', to: 'contact#index', as: 'contact'
  get '/:category', to: 'posts#index', as: 'posts', constraints: { category: /(translations|blogs)/ }
  get '/:category/:id', to: 'posts#show', as: 'post', constraints: { category: /(translations|blogs)/ }
end
