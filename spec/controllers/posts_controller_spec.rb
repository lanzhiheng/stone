require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  render_views

  before(:context) do
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
  end

  describe "List Page" do
    it "has active navbar on translation text" do
      get :index, params: { category: 'translations' }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Translation")
    end

    it "has active navbar on blog text" do
      get :index, params: { category: 'blogs' }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Blog")
    end


    it "should not access pages without `blogs` or `translations` category" do
      expect {
        get :index, params: { category: 'books' }
      }.to raise_error(ActionController::UrlGenerationError)
    end

    it "contain title and meta" do
      (1..3).each do |i|
        Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: @blog, draft: false)
      end

      (4..6).each do |i|
        Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: @translation, draft: false)
      end

      def test_post_list(category, count)
        get :index, params: { category: category }
        expect(response.body).to have_tag("ul.post-list", count: 1)
        expect(response.body).to have_tag("li.inline-post-wrapper", count: count)
        expect(response.body).to have_tag("span.post-meta", count: count)
      end

      test_post_list(@translation.key, 3)
      test_post_list(@blog.key, 3)
    end

    it "posts list with pagination" do
      (1..11).each do |i|
        Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: @blog, draft: false)
      end

      get :index, params: { category: @blog.key }
      expect(response.body).to have_tag('li.inline-post-wrapper', count: 10)
      expect(response.body).to have_tag('.pager', count: 1)
      expect(response.body).to have_tag('.previous_page', text: '←')
      expect(response.body).to have_tag('.next_page', text: '→')
    end

    it "draft posts not display in list" do
      (1..11).each do |i|
        Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: @blog)
      end

      (12..13).each do |i|
        Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: @blog, draft: false)
      end

      get :index, params: { category: @blog.key }
      expect(response.body).to have_tag('li.inline-post-wrapper', count: 2)
    end

  end

  describe "Detail Page" do
    it "has active navbar on translation text" do
      post = create(:post, category: @translation, draft: false)
      get :show, params: { category: @translation.key, id: post.slug }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Translation")
    end

    it "has active navbar on blog text" do
      post = create(:post, category: @blog, draft: false)
      get :show, params: { category: @blog.key, id: post.slug }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Blog")
    end

    it "should not access without `blogs` or `translations` category" do
      expect {
        get :show, params: { category: 'books' }
      }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  after(:context) do
    Post.destroy_all
    Category.destroy_all
  end
end
