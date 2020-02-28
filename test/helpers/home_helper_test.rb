require 'test_helper'

class HomeHelperTest < ActionView::TestCase
  test "should contain lastest posts" do
    assert_equal lastest_posts, Post.published.limit(10).reverse
  end
end
