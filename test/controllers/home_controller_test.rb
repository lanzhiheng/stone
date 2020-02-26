require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should contain home section with post-list" do
    post = posts.first.clone
    post.slug = 'for-testing'
    post.tag_list = 'Ruby, JavaScript, Rails'
    assert post.save

    get root_url

    assert_select 'div.home' do
      assert_select 'ul.post-list' do
        assert_select "li.post-wrapper", posts.size do
          assert_select "a.post-title", posts.size
          assert_select "div.post-meta", posts.size
          assert_select "p.post-excerpts", posts.size
          assert_select "div.btn-wrapper" do
            assert_select "a.read-more"
          end
          assert_select 'div.tag-list', 1
        end
      end
    end
  end

  test "should get index with lastest navbar active" do
    get root_url
    assert_select('.nav > li > a.active', 'Lastest')
  end
end
