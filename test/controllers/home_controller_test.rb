require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should contain home section with post-list" do
    get root_url
    assert_select 'div.home' do
      assert_select 'ul.post-list' do
        assert_select "li.post-wrapper", 2 do
          assert_select "a.post-title", 2
          assert_select "span.post-meta", 2
          assert_select "p.post-excerpts", 2
          assert_select "div.btn-wrapper" do
            assert_select "a.read-more"
          end
        end
      end
    end
  end

  test "should get index with lastest navbar active" do
    get root_url
    assert_select('.nav > li > a.active', 'Lastest')
  end
end
