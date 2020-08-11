# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  let!(:translation) { create(:category, :translation) }
  let!(:blog) { create(:category, :blog) }

  context 'create post' do
    it 'without title' do
      before = Post.count
      expect do
        create(:post, title: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'without category' do
      before = Post.count
      expect do
        create(:post, category: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'without body' do
      before = Post.count
      expect do
        create(:post, body: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'without slug' do
      before = Post.count
      expect do
        create(:post, slug: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'with slug, body, title, category' do
      before = Post.count
      create(:post)
      expect(Post.count).to eq before + 1
    end

    it 'slug must be uniq' do
      post = create(:post)
      expect do
        create(
          :post,
          title: "#{post.title}_copy",
          body: "#{post.body}_copy"
        )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'attributes' do
    after(:each) do
      Post.destroy_all
    end

    it 'published posts' do
      (1..5).each do |i|
        create(:post, title: "title-#{i}", slug: "slug-#{i}", category: blog, draft: false)
      end
      expect(Post.published.size).to eq 5

      (6..10).each do |i|
        create(:post, title: "title-#{i}", slug: "slug-#{i}", category: blog)
      end
      expect(Post.published.size).to eq 5
    end

    it 'the content attribute is the result of the markdown parser' do
      post = create(:post, body: '**Markdown**')
      expect(post.content.strip).to eq '<p><strong>Markdown</strong></p>'
    end

    it 'taggable' do
      post = create(:post, tag_list: 'Ruby, JavaScript, Life')
      expect(post.tags.size).to eq 3
    end

    it "retrieve posts by category's key" do
      (1..5).each do |i|
        create(:post, title: "title-blog-#{i}", slug: "slug-blog-#{i}", category: blog)
        create(:post, title: "title-translation-#{i}", slug: "slug-category-#{i}", category: translation)
      end
      expect(Post.category(blog.key).size).to eq 5
      expect(Post.category(translation.key).size).to eq 5
    end
  end
end
