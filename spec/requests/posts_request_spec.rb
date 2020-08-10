# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts' do
  include Devise::Test::IntegrationHelpers

  let(:admin_user) { create(:admin_user) }

  before(:context) do
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
    @book = create(:category, :book)

    @post_from_blog = Post.create(title: 'post1', body: 'body', slug: 'blog-post-slug', category: @blog, draft: false)
    @post_from_book = Post.create(title: 'post2', body: 'body', slug: 'book-post-slug', category: @book, draft: false)
    @post_from_translation = Post.create(
      title: 'post3',
      body: 'body',
      slug: 'translation-post-slug',
      category: @translation,
      draft: false
    )
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

  describe 'Navbar' do
    it 'highlight the navbar in list page' do
      [@blog, @translation, @book].each do |item|
        get posts_path(item.key)
        expect(response.body).to have_tag('.nav > li > a.active', text: item.name)
      end
    end

    it 'highlight the navbar in detail page' do
      [@post_from_blog, @post_from_book, @post_from_translation].each do |post|
        get post_path(post)
        expect(response.body).to have_tag('.nav > li > a.active', text: post.category.name)
      end
    end
  end

  it 'redirect old url to new url with 301 code, new url prefix by posts' do
    get "/posts/#{@post_from_blog.slug}"
    expect(response).to have_http_status(200)
    get "/posts/#{@post_from_book.slug}"
    expect(response).to have_http_status(200)

    get "/#{@blog.key}/#{@post_from_blog.slug}"
    expect(response).to have_http_status(301)
    get "/#{@blog.key}/#{@post_from_book.slug}"
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
      get post_preview_path(@post_from_blog.slug)
    end.to raise_error(ActionController::RoutingError, 'Page Not Found')

    sign_in admin_user

    get post_preview_path(@post_from_blog.slug)
    expect(response).to have_http_status(200)
    get post_preview_path(@post_from_book.slug)
    expect(response).to have_http_status(200)

    expect do
      get post_preview_path('nothing')
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  after(:context) do
    Post.destroy_all
    Category.destroy_all
  end
end
