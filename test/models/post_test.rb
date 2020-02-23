require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    article = Post.new
    assert_not article.save
  end

  test "should not save post without body" do
    article = Post.new(title: 'title1')
    assert_not article.save
  end

  test "can save post with title and body" do
    article = Post.new(title: 'title1', body: 'hello')
    assert article.save
  end
end
