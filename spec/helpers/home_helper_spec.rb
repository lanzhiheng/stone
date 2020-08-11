# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeHelper do
  let!(:blog) { create(:category, :blog) }

  it 'lastest posts' do
    (1..20).each do |i|
      Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: blog, draft: false)
    end

    expect(lastest_posts.size).to eq 15
    expect(lastest_posts).to eq Post.published.limit(15).order('created_at desc')
  end
end
