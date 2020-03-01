require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  render_views

  before(:context) do
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
  end

  describe "List Page" do
    it "has active navbar on translation text" do
      get :index, params: { category: 'translations' }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Translation")
    end

    it "has active navbar on blog text" do
      get :index, params: { category: 'blogs' }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Blog")
    end
  end

  describe "Detail Page" do
    it "has active navbar on translation text" do
      post = create(:post, category: @translation, draft: false)
      get :show, params: { category: @translation.key, id: post.slug }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Translation")
    end

    it "has active navbar on blog text" do
      post = create(:post, category: @blog, draft: false)
      get :show, params: { category: @blog.key, id: post.slug }
      expect(response.body).to have_tag(".nav > li > a.active", text: "Blog")
    end
  end

  after(:context) do
    Category.destroy_all
  end
end
