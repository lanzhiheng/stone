class CategoryConstraint
  def matches?(request)
    category = request.params[:category]

    return true if Category.pluck(:key).include?(category)
    raise ActionController::RoutingError.new("The category #{category} is nonexistent.")
  end
end

Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # namespace :musk do
  #   resources :sessions
  # end

  namespace :musk do
    root 'dashboards#index'
    resources :posts do
      member do
        put :toggle
      end
    end
    resources :categories
    devise_scope :admin_user do
      get 'sign_in', to: 'sessions#new'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
      # resources :sessions
    end
  end

  devise_for :admin_users, controllers: { sessions: 'musk/sessions' }

  get '/lastest', to: 'home#index'
  get '/about', to: 'resumes#index', as: 'about'
  # get '/personal', to: 'resumes#personal'
  get '/tags', to: 'tags#index', as: 'tags'

  resources :messages, only: [:create, :new]
  get '/contact', to: 'messages#new'

  put '/upload', to: 'image_uploader#upload'

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  get "/robots.:format", to: "pages#robots"

  resources :posts do
    member do
      get :preview
    end
  end

  constraints(CategoryConstraint.new) do
    get '/:category', to: 'posts#index', as: :category
    get '/:category/:id', to: redirect('/posts/%{id}')
  end
end
