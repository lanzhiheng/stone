require 'rails_helper'

RSpec.describe Post, type: :model do
  fixtures :posts
  before(:context) do
    create(:category, :translation)
    create(:category, :blog)
  end

  context 'create post' do
    it 'without title' do
      before = Post.count
      expect {
        create(:post, title: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'without category' do
      before = Post.count
      expect {
        create(:post, category: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'without body' do
      before = Post.count
      expect {
        create(:post, body: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'without slug' do
      before = Post.count
      expect {
        create(:post, slug: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Post.count).to eq before
    end

    it 'with slug, body, title, category' do
      before = Post.count
      create(:post)
      expect(Post.count).to eq before + 1
    end

    it 'slug must be uniq' do
      post = create(:post)
      expect {
        create(
          :post,
          title: "#{post.title}_copy",
          body: "#{post.body}_copy"
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'attributes' do
    it "published posts" do
      expect(Post.published.size).to eq 3
    end

    it "the content attribute is the result of the markdown parser" do
      post = create(:post, body: '**Markdown**')
      expect(post.content.strip).to eq '<p><strong>Markdown</strong></p>'
    end

    it "taggable" do
      post = create(:post, tag_list: 'Ruby, JavaScript, Life')
      expect(post.tags.size).to eq 3
    end
  end

  after(:context) do
    Category.destroy_all
  end
end
