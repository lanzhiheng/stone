require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:context) do
    @admin_user = AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
  end

  describe "Tags List" do
    it "Most Used tags" do
      @post = Post.create(title: "title", body: "body", slug: "slug", category: @blog, draft: false)
      @post.tag_list = "hello, hi, java, javascript, hello world"
      @post.save

      sign_in @admin_user
      get :index
      expect(json["data"].class).to be(Array)
      expect(json["data"].length).to be(5)
    end
  end

  after(:context) do
    Post.destroy_all
    Category.destroy_all
    AdminUser.destroy_all
  end
end
