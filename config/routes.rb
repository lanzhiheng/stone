Rails.application.routes.draw do
  resources :resumes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/lastest', to: 'home#index'
  get '/about', to: 'resumes#index', as: 'about'
  get '/contact', to: 'contact#index', as: 'contact'
  get '/tags', to: 'tags#index', as: 'tags'
  post '/contact-me', to: 'messages#create', as: 'contact_me'
  put '/upload', to: 'image_uploader#upload'

  constraints(category: /(translations|blogs)/) do
    get '/:category', to: 'posts#index', as: 'posts'
    get '/:category/:id', to: 'posts#show', as: 'post'
    get '/:category/preview/:id', to: 'posts#preview', as: 'post_preview'
  end

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  get "/robots.:format", to: "pages#robots"
end
