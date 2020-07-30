# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts', type: :request do
  include Devise::Test::IntegrationHelpers

  before(:context) do
    @admin_user = AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
    @book = create(:category, :book)

    @post1 = Post.create(title: 'post1', body: 'body', slug: 'blog-post-slug', category: @blog, draft: false)
    @post2 = Post.create(title: 'post2', body: 'body', slug: 'book-post-slug', category: @book, draft: false)
  end

  it "should access index pages with validated category's key" do
    get posts_path(@blog.key)
    expect(response).to have_http_status(200)
    get posts_path(@book.key)
    expect(response).to have_http_status(200)

    expect do
      get '/invalid-catetory'
    end.to raise_error(ActionController::RoutingError)
  end

  it 'redirect old url to new url with 301 code, new url prefix by posts' do
    get "/posts/#{@post1.slug}"
    expect(response).to have_http_status(200)
    get "/posts/#{@post2.slug}"
    expect(response).to have_http_status(200)

    get "/#{@blog.key}/#{@post1.slug}"
    expect(response).to have_http_status(301)
    get "/#{@blog.key}/#{@post2.slug}"
    expect(response).to have_http_status(301)

    expect do
      get '/posts/invalid-slug'
    end.to raise_error(ActiveRecord::RecordNotFound)

    expect do
      get '/invalid-category/invalid-slug'
    end.to raise_error(ActionController::RoutingError)
  end

  it 'Admin user can access the preview page' do
    expect do
      get post_preview_path(@post1.slug)
    end.to raise_error(ActionController::RoutingError, 'Page Not Found')

    sign_in @admin_user

    get post_preview_path(@post1.slug)
    expect(response).to have_http_status(200)
    get post_preview_path(@post2.slug)
    expect(response).to have_http_status(200)

    expect do
      get post_preview_path('nothing')
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  after(:context) do
    Post.destroy_all
    Category.destroy_all
    AdminUser.destroy_all
  end
end
