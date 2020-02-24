require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "post detail page contain title" do
    post = posts.first

    get post_url(post)
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
