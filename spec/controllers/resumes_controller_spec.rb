# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResumesController, type: :controller do
  render_views

  it 'display first two resumes' do
    (1..3).each do |i|
      create(:resume, title: "title-#{i}", description: "## hello#{i}")
    end
    get :index
    expect(response.body).to have_tag('.resume', count: 2)
  end

  it 'meta data for resume page' do
    get :index
    expect(response.body).to have_tag('title', 'About')
    expect(response.body).to have_tag('meta', with: {
                                        name: 'keywords',
                                        content: DEFAULT_META['keywords']
                                      })
    expect(response.body).to have_tag('meta', with: {
                                        name: 'description',
                                        content: 'Simple description of the author.'
                                      })
  end
end
