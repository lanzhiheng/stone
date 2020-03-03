require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "post detail page contain title" do
    post = posts.first

    get post_url(post.category.key, post.slug)
    assert_select 'article.post' do
      assert_select 'header.post-header' do
        assert_select 'h1.post-title', post.title
        assert_select "div.post-meta" do
          assert_select "div.time-wrapper" do
            assert_select "time.created-at"
            assert_select "time.updated-at"
          end
        end
      end

      assert_select 'div.post-content', post.body
    end
  end

  test "post detail page can not access draft post" do
    post = Post.where(draft: true).first

    assert_raises(ActiveRecord::RecordNotFound) do
      get post_url(post.category.key, post.slug)
    end
  end

  test "post preview page can access draft post" do
    post = Post.where(draft: true).first

    assert_raises(ActionController::RoutingError) do
      get post_preview_url(post.category.key, post.slug)
    end

    sign_in admin_users(:one)
    get post_preview_url(post.category.key, post.slug)
    assert_select 'article.post' do
      assert_select 'header.post-header' do
        assert_select 'h1.post-title', post.title
        assert_select "div.post-meta" do
          assert_select "div.time-wrapper" do
            assert_select "time.created-at"
            assert_select "time.updated-at"
          end
        end
      end

      assert_select 'div.post-content', post.body
    end
  end

  test "post detail page with comment" do
    post = posts.first
    get post_url(post.category.key, post.slug)
    assert_select '#disqus_thread'
  end

  test "post detail page with taglist" do
    post = posts.first.clone
    post.tag_list = 'Ruby, JavaScript, Rails'
    assert post.save
    get post_url(post.category.key, post.slug)
    assert_select 'div.tag-list'
    assert_select 'div.tag-list .tag', 3
  end

  test "post title as the tab title" do
    post = posts.first
    get post_url(post.category.key, post.slug)
    assert_select 'title', post.title
  end

  test "Check blog posts page title" do
    get posts_url('blogs')
    assert_select 'title', 'blogs'
  end

  test "Check translation posts page title" do
    get posts_url('translations')
    assert_select 'title', 'translations'
  end
end
