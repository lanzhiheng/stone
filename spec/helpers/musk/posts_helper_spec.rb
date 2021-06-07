# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Musk::PostsHelper, type: :helper do
  it 'toggle link' do
    post = create(:post)
    expect(post.draft).to eq(true)
    expect(toggle_link(post)).to have_tag('.stone-link', text: '上架', id: "toggle_link_#{post.id}")
    post.update(draft: false)
    expect(toggle_link(post)).to have_tag('.stone-link', text: '下架', id: "toggle_link_#{post.id}")
  end

  it 'toggle button' do
    post = create(:post)
    expect(post.draft).to eq(true)
    expect(toggle_button(post)).to have_tag('.btn', text: '上架', id: "toggle_button_#{post.id}")
    post.update(draft: false)
    expect(toggle_button(post)).to have_tag('.btn', text: '下架', id: "toggle_button_#{post.id}")
  end
end
