# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  render_views

  let!(:blog) { create(:category, :blog) }

  it 'should get index' do
    get :index
    expect(response.code).to eq '200'
  end

  it 'title of home' do
    get :index
    expect(response.body).to have_tag('title', text: DEFAULT_META['title'])
    expect(response.body).to have_tag('meta', with: {
                                        name: 'keywords',
                                        content: DEFAULT_META['keywords']
                                      })
    expect(response.body).to have_tag('meta', with: {
                                        name: 'author',
                                        content: DEFAULT_META['author']
                                      })
    expect(response.body).to have_tag('meta', with: {
                                        name: 'description',
                                        content: DEFAULT_META['description']
                                      })
  end

  it "Don't display the draft post" do
    (1..3).each do |i|
      create(:post, title: "title-#{i}", slug: "slug-#{i}", category: blog)
    end

    (4..6).each do |i|
      create(:post, title: "title-#{i}", slug: "slug-#{i}", category: blog, draft: false)
    end

    get :index
    expect(response.body).to have_tag('div.home')
    expect(response.body).to have_tag('ul.post-list')
    expect(response.body).to have_tag('li.post-wrapper', count: 3)
  end

  it 'At most 15 items in home page' do
    (1..20).each do |i|
      create(:post, title: "title-#{i}", slug: "slug-#{i}", category: blog, draft: false)
    end

    get :index
    expect(response.body).to have_tag('div.home')
    expect(response.body).to have_tag('ul.post-list')
    expect(response.body).to have_tag('li.post-wrapper', count: 15)
  end

  it 'should contain post list' do
    (1..5).each do |i|
      create(:post, title: "title-#{i}", slug: "slug-#{i}", category: blog, draft: false, tag_list: %w[hello world])
    end

    get :index

    expect(response.body).to have_tag('div.home')
    expect(response.body).to have_tag('ul.post-list')
    expect(response.body).to have_tag('li.post-wrapper', count: 5)
    expect(response.body).to have_tag('time.created-at', count: 5)
    expect(response.body).to have_tag('p.post-excerpts', count: 5)
    expect(response.body).to have_tag('a.read-more')
    expect(response.body).to have_tag('div.tag-list', count: 5)
  end
end
