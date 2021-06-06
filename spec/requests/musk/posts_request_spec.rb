# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Musk::Posts', type: :request do
  describe 'request about toggle' do
    it 'need login' do
      post = create(:post)
      put toggle_musk_post_path(post)
      expect(response.status).to eq(302)
    end

    it 'toggle functionality' do
      user = create(:admin_user)
      sign_in(user)
      post = create(:post)
      expect(post.draft).to be(true)
      put toggle_musk_post_path(post)
      expect(post.reload.draft).to be(false)
      put toggle_musk_post_path(post)
      expect(post.reload.draft).to be(true)
    end
  end
end
