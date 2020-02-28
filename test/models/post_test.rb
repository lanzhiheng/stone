require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    article = Post.new(body: 'body', slug: 'slug', category: categories.first)
    assert_not article.save
  end

  test "should not save post without body" do
    article = Post.new(title: 'title', slug: 'slug', category: categories.first)
    assert_not article.save
  end

  test "should not save post without slug" do
    article = Post.new(title: 'title', body: 'body', category: categories.first)
    assert_not article.save
  end

  test "can not save post without category" do
    article = Post.new(title: 'title1', body: 'hello', slug: 'hello')
    assert_not article.save
  end

  test "published posts" do
    assert_equal Post.published.size, 3
  end

  test "can save post with title, body, category and slug" do
    article = Post.new(
      title: 'title1',
      body: 'hello',
      category: categories.first,
      slug: 'slug')
    assert article.save
  end

  test "the slug must be unique" do
    article1 = Post.new(title: 'title1', body: 'body1', category: categories.first, slug: 'slug')
    article2 = Post.new(title: 'title2', body: 'body2', category: categories.first, slug: 'slug')
    assert article1.save
    assert_not article2.save
  end

  test "can render the markdown with content attribute" do
    article = Post.new(title: 'title1', body: '**Markdown**', category: categories.first)
    article.save
    assert_equal article.content.strip, '<p><strong>Markdown</strong></p>'
  end

  test "the taggable post" do
    article = Post.new(title: 'tagTitle', body: 'tagBody', category: categories.first, slug: 'tag-slug', tag_list: 'Ruby, JavaScript, Life')
    assert article.save
    assert_equal article.tags.size, 3
  end

  test "default draft post" do
    assert_equal posts.first.draft, false
    article = Post.new(title: 'tagTitle', body: 'tagBody', category: categories.first, slug: 'tag-slug', tag_list: 'Ruby, JavaScript, Life')
    assert article.save
    assert_equal article.draft, true
  end
end
