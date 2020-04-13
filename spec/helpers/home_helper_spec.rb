require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  it "lastest posts" do
    @blog = create(:category)
    (1..20).each do |i|
      Post.create(title: "title-#{i}", body: "body-#{i}", slug: "slug-#{i}", category: @blog, draft: false)
    end

    expect(lastest_posts.size).to eq 15
    expect(lastest_posts).to eq Post.published.limit(15).order('created_at desc')
  end
end
