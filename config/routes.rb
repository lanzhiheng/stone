Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/blogs/:id', to: 'posts#show', as: 'blog'
  get '/blogs', to: 'posts#index', as: 'blogs'
  get '/about', to: 'about#index', as: 'about'
  get '/contact', to: 'contact#index', as: 'contact'
end
