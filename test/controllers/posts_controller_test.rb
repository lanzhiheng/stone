require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get blog list with navbar active" do
    get blogs_url
    assert_select('.nav > li > a.active', 'Blog')
  end

  test "should get blog detail with navbar active" do
    get blog_url(posts.first)
    assert_select('.nav > li > a.active', 'Blog')
  end

  test "post index page contain title" do
    post = posts.first

    get blogs_url
    assert_select 'ul.post-list' do
      assert_select 'li.inline-post-wrapper', posts.size
      assert_select 'span.post-meta', posts.size
    end
  end


  test "post detail page contain title" do
    post = posts.first

    get blog_url(post)
    assert_select 'article.post' do
      assert_select 'header.post-header' do
        assert_select 'h1.post-title', post.title
        assert_select 'p.post-meta' do
          assert_select 'time.dt-published', post.created_at.strftime('%A, %Y-%m-%d')
        end
      end

      assert_select 'div.post-content', post.body
    end
  end
end
