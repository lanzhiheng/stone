require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before(:context) do
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
    @book = create(:category, :book)
  end

  describe "List Page" do
    it "title of index Page" do
      get :index, params: { category: @translation.key }
      expect(response.body).to have_tag("title", text: @translation.key )
      expect(response.body).to have_tag("meta", with: {
                                          name: 'keywords',
                                          content: DEFAULT_META["keywords"]
                                        })
      expect(response.body).to have_tag("meta", with: {
                                          name: 'author',
                                          content: DEFAULT_META["author"]
                                        })
      expect(response.body).to have_tag("meta", with: {
                                          name: 'description',
                                          content: DEFAULT_META["description"]
                                        })
    end

    it "has active navbar on translation text" do
      get :index, params: { category: 'translations' }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Translation")
    end

    it "has active navbar on blog text" do
      get :index, params: { category: 'blogs' }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Blog")
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

    it "Category as title" do
      get :index, params: { category: @blog.key }
      expect(response.body).to have_tag('title', text: @blog.key)

      get :index, params: { category: @translation.key }
      expect(response.body).to have_tag('title', text: @translation.key)

    end
  end

  describe "Detail Page" do
    it "title of detail Page" do
      post = create(:post, category: @translation, draft: false, excerpt: "Good Article", tag_list: "a, b, c, d" )
      get :show, params: { category: @translation.key, id: post.slug }
      expect(response.body).to have_tag("title", text: post.title)
      expect(response.body).to have_tag("meta", with: {
                                          name: "keywords",
                                          content: post.tags.join(", ")
                                        })
      expect(response.body).to have_tag("meta", with: {
                                          name: "author",
                                          content: DEFAULT_META["author"]
                                        })
      expect(response.body).to have_tag("meta", with: {
                                          name: "description",
                                          content: "Good Article"
                                        })
    end

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

    it "contain the structed-data" do
      post = create(:post, category: @blog, draft: false)
      get :show, params: { category: @blog.key, id: post.slug }
      expect(response.body).to have_tag("script", with: { type: "application/ld+json" })
    end

    def expect_for_detail_page(post)
      expect(response.body).to have_tag('article.post')
      expect(response.body).to have_tag('header.post-header')
      expect(response.body).to have_tag('h1.post-title', text: post.title)
      expect(response.body).to have_tag('div.post-meta')
      expect(response.body).to have_tag('time.created-at', text: post.created_at.strftime("Date: %Y-%m-%d %H:%M"))
      expect(response.body).to have_tag('time.updated-at', text: post.updated_at.strftime("Last Updated: %Y-%m-%d %H:%M"))
      expect(response.body).to have_tag('div.post-content')
    end

    it "content of page" do
      post = create(:post, category: @blog, draft: false)
      get :show, params: { category: @blog.key, id: post.slug }
      expect_for_detail_page(post)
    end

    it "fetch detail with correct category" do
      post = create(:post, category: @blog, draft: false)

      assert_raises(ActiveRecord::RecordNotFound) do
        get :show, params: { category: @translation.key, id: post.slug }
      end
    end

    it "not display the draft post" do
      post = create(:post, category: @blog, draft: true)

      assert_raises(ActiveRecord::RecordNotFound) do
        get :show, params: { category: @blog.key, id: post.slug }
      end
    end

    describe "admin user page" do
      before(:context) do
        @draft_post = create(:post, category: @blog, draft: true)
        @admin_user = AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
      end

      after(:context) do
        @draft_post.destroy
        @admin_user.destroy
      end

      it "can not preview the draft post if non-login" do
        expect {
          get :preview, params: { category: @blog.key, id: @draft_post.slug }
        }.to raise_error(ActionController::RoutingError)
      end

      it "can preview the draft post if login" do
        sign_in @admin_user
        get :preview, params: { category: @blog.key, id: @draft_post.slug }
        expect_for_detail_page(@draft_post)
      end

      it "preview the draft with correct category" do
        sign_in @admin_user
        get :preview, params: { category: @blog.key, id: @draft_post.slug }
      end

      it "can not preview the draft post with wrong category" do
        sign_in @admin_user
        assert_raises(ActiveRecord::RecordNotFound) do
          get :show, params: { category: @translation.key, id: @draft_post.slug }
        end
      end
    end

    it "will load disqus component" do
      post = create(:post, category: @blog, draft: false)
      get :show, params: { category: @blog.key, id: post.slug }
      expect(response.body).to have_tag('#disqus_thread')
    end

    it "with taglist" do
      post = build(:post, category: @blog, draft: false)
      post.tag_list = 'Ruby, JavaScript, Rails'
      post.save

      get :show, params: { category: @blog.key, id: post.slug }
      expect(response.body).to have_tag('div.tag-list .tag', count: 3)
    end

    it "set post title as the tab title" do
      post = create(:post, category: @blog, draft: false)
      get :show, params: { category: @blog.key, id: post.slug }
      expect(response.body).to have_tag('title', text: post.title)
    end
  end

  after(:context) do
    Post.destroy_all
    Category.destroy_all
  end
end
