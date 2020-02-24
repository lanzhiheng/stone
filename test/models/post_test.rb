require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    article = Post.new(body: 'body1')
    assert_not article.save
  end

  test "should not save post without body" do
    article = Post.new(title: 'title1')
    assert_not article.save
  end

  test "can not save post without category" do
    article = Post.new(title: 'title1', body: 'hello')
    assert_not article.save
  end

  test "can save post with title, body and category" do
    article = Post.new(title: 'title1', body: 'hello', category: categories.first)
    assert article.save
  end

  test "can render the markdown with content attribute" do
    article = Post.new(title: 'title1', body: '**Markdown**', category: categories.first)
    article.save
    assert_equal article.content.strip, '<p><strong>Markdown</strong></p>'
  end
end
