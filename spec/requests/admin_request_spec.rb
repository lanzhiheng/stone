require 'rails_helper'

RSpec.describe "admin posts", type: :request do
  include Devise::Test::IntegrationHelpers

  before(:context) do
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    @translation = create(:category, :translation)
    @blog = create(:category, :blog)
  end

  describe "GET /posts" do
    it "returns http success" do
      admin_user = AdminUser.first
      get admin_posts_url
      expect(response.code).to eq '302'
      sign_in admin_user
      get admin_posts_url
      expect(response.code).to eq '200'
    end

    it "Just with view, edit, preview, handle link, without delete link" do
      admin_user = AdminUser.first
      post = create(:post, category: @blog)

      sign_in admin_user

      get admin_posts_url
      expect(response.body).to have_tag('.view_link.member_link', count: 1, text: 'View')
      expect(response.body).to have_tag('.edit_link.member_link', count: 1, text: 'Edit')
      expect(response.body).to have_tag('.preview_link.member_link', count: 1, text: 'Preview')
      expect(response.body).to have_tag('.handle_link.member_link', count: 1, text: 'Publish')
      expect(response.body).not_to have_tag('.delete_link.member_link')
    end
  end

  describe "GET /posts/:id/edit" do
    it "returns http success" do
      admin_user = AdminUser.first
      post = create(:post, category: @blog)
      get admin_post_url(post)
      expect(response.code).to eq '302'
      sign_in admin_user
      get admin_post_url(post)
      expect(response.code).to eq '200'
    end

    it "post body form with md_editor id" do
      admin_user = AdminUser.first
      post = create(:post, category: @blog, tag_list: 'hello, world')
      sign_in admin_user

      get edit_admin_post_url(post)
      expect(response.body).to have_tag('.markdown-wrapper')
    end
  end

  describe "GET /posts/:id" do
    it "returns http success" do
      admin_user = AdminUser.first
      post = create(:post, category: @blog)
      get admin_post_url(post)
      expect(response.code).to eq '302'
      sign_in admin_user
      get admin_post_url(post)
      expect(response.code).to eq '200'
    end

    it "Show title, body, excerpt, tag list, created_at, updated_at" do
      admin_user = AdminUser.first
      post = create(:post, category: @blog, tag_list: 'hello, world')
      sign_in admin_user

      get admin_post_url(post)
      expect(response.body).to have_tag('.row-title > td', text: post.title)
      expect(response.body).to have_tag('.row-body > td', text: post.body)
      expect(response.body).to have_tag('.row-excerpt > td', text: post.excerpt)
      expect(response.body).to have_tag('.row-created_at > td', text: post.created_at.strftime("%Y-%m-%d %H:%M"))
      expect(response.body).to have_tag('.row-updated_at > td', text: post.updated_at.strftime("%Y-%m-%d %H:%M"))
      expect(response.body).to have_tag('.row-tag_list > td', count: 1)
      expect(response.body).to have_tag('.row-draft > td', count: 1)
    end
  end

  after(:context) do
    AdminUser.destroy_all
    Post.destroy_all
    Category.destroy_all
  end
end
