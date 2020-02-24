require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  attr_accessor :request
  @request = {}

  test "should return navbar link" do
    assert_dom_equal %{<ul class="nav"><li><a href="/">Lastest</a></li><li><a href="/blogs">Blog</a></li><li><a href="/translation">Translation</a></li><li><a href="/about">About</a></li><li><a href="/contact">Contact</a></li></ul>}, navbar
  end

  test "should return social link" do
    assert_dom_equal %{<ul class="social"><a target="_blank" href="https://github.com/lanzhiheng"><i class="fab fa-github"></i></a><a target="_blank" href="https://www.weibo.com/u/2174832927"><i class="fab fa-weibo"></i></a><a target="_blank" href="https://twitter.com/lanzhiheng"><i class="fab fa-twitter"></i></a><a target="_blank" href="mailto:lanzhihengrj@gmail.com"><i class="far fa-envelope"></i></a></ul>}, social
  end

  test "active path" do
    assert_equal(current_class(''), 'active')
    assert_equal(current_class('/blog'), '')
  end
end
