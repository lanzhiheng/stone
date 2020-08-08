# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'errors page' do
  def expect_helper(code, text)
    expect(response.body).to have_tag('div.header-content')
    expect(response.body).to have_tag('div.error-info')
    expect(response.body).to have_tag('div.error-code', code)
    expect(response.body).to have_tag('div.error-message', text)
  end

  it 'return 404 page if some page not found with suffix .txt' do
    expect do
      get '/the-not-exist-page.txt'
    end.to raise_error(ActionController::RoutingError)
  end

  it 'return 404 page if with suffix 400.txt' do
    get '/404.txt'
    expect_helper('404', 'Not Found')
  end

  it 'return 500 page if with suffix 500.txt' do
    get '/500.txt'
    expect_helper('500', 'Internal Server Error')
  end
end
