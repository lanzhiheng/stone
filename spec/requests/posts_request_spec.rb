require 'rails_helper'

RSpec.describe "posts", type: :request do
  include Devise::Test::IntegrationHelpers

  before(:context) do
    @admin_user = AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
    @book = create(:category, :book)

    @post1 = Post.create(title: "post1", body: "body", slug: "blog-post-slug", category: @blog, draft: false)
    @post2 = Post.create(title: "post2", body: "body", slug: "book-post-slug", category: @book, draft: false)
  end

  it "should access index pages with validated category's key" do
    get posts_path(@blog.key)
    expect(response).to have_http_status(200)
    get posts_path(@book.key)
    expect(response).to have_http_status(200)

    expect {
      get "/invalid-catetory"
    }.to raise_error(ActionController::RoutingError)
  end

  it "should access detail pages with validated category's key" do
    get post_path(@blog.key, @post1.slug)
    expect(response).to have_http_status(200)
    get post_path(@book.key, @post2.slug)
    expect(response).to have_http_status(200)

    expect {
      get post_path(@translation.key, @post1.slug)
    }.to raise_error(ActiveRecord::RecordNotFound)

    expect {
      get post_path("invalid-catetory", @post1.slug)
    }.to raise_error(ActionController::RoutingError)
  end

  it "should access detail pages with validated category's key" do
    sign_in @admin_user

    get post_preview_path(@blog.key, @post1.slug)
    expect(response).to have_http_status(200)
    get post_preview_path(@book.key, @post2.slug)
    expect(response).to have_http_status(200)

    expect {
      get post_preview_path(@translation.key, @post1.slug)
    }.to raise_error(ActiveRecord::RecordNotFound)

    expect {
      get post_preview_path("invalid-category", @post1.slug)
    }.to raise_error(ActionController::RoutingError)
  end

  after(:context) do
    Post.destroy_all
    Category.destroy_all
    AdminUser.destroy_all
  end

end
