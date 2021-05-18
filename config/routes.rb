class CategoryConstraint
  def matches?(request)
    category = request.params[:category]

    return true if Category.pluck(:key).include?(category)
    raise ActionController::RoutingError.new("The category #{category} is nonexistent.")
  end
end

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # namespace :musk do
  #   resources :sessions
  # end

  namespace :musk do
    devise_scope :admin_user do
      get 'sign_in', to: 'sessions#new'
      post 'sign_in', to: 'sessions#create'
      # resources :sessions
    end
  end

  # devise_for :admin_users, controllers: { sessions: 'musk/sessions' }


  get '/lastest', to: 'home#index'
  get '/about', to: 'resumes#index', as: 'about'
  # get '/personal', to: 'resumes#personal'
  get '/contact', to: 'contact#index', as: 'contact'
  get '/tags', to: 'tags#index', as: 'tags'
  post '/contact-me', to: 'messages#create', as: 'contact_me'
  put '/upload', to: 'image_uploader#upload'

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  get "/robots.:format", to: "pages#robots"

  get '/posts/:id', to: 'posts#show', as: 'post'
  get '/posts/preview/:id', to: 'posts#preview', as: 'post_preview'

  constraints(CategoryConstraint.new) do
    get '/:category', to: 'posts#index', as: 'posts'
    get '/:category/:id', to: redirect('/posts/%{id}')
  end
end
