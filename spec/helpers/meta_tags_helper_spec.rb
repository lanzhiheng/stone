# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetaTagsHelper do
  it 'Can load DEFAULT_META constant' do
    result = YAML.load_file(Rails.root.join('config/meta.yml'))
    expect(DEFAULT_META).to eq(result)
  end

  it 'Meta title configurable' do
    expect(meta_title).to eq(DEFAULT_META.dig('title'))
    content_for(:title, 'Hello')
    expect(meta_title).to eq('Hello')
  end

  it 'Meta description configurable' do
    expect(meta_description).to eq(DEFAULT_META.dig('description'))
    content_for(:description, 'Hello Ruby')
    expect(meta_description).to eq('Hello Ruby')
  end

  it 'Meta keywords configurable' do
    expect(meta_keywords).to eq(DEFAULT_META.dig('keywords'))
    content_for(:keywords, 'hello, hi, ruby')
    expect(meta_keywords).to eq('hello, hi, ruby')
  end

  it 'Meta image not configurable' do
    expect(meta_image).to eq(DEFAULT_META.dig('image'))
    content_for(:image, 'avatar.jpg')
    expect(meta_image).to eq(DEFAULT_META.dig('image'))
  end

  it 'Meta author not configurable' do
    expect(meta_author).to eq(DEFAULT_META.dig('author'))
    content_for(:author, 'hello hello')
    expect(meta_author).to eq(DEFAULT_META.dig('author'))
  end
end
