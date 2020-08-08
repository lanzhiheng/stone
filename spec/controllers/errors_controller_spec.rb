# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorsController do
  render_views

  describe 'GET error pages' do
    def expect_helper(code, text)
      expect(response.body).to have_tag('div.header-content')
      expect(response.body).to have_tag('div.error-info')
      expect(response.body).to have_tag('div.error-code', code)
      expect(response.body).to have_tag('div.error-message', text)
    end

    it '404 page' do
      get :not_found
      expect_helper('404', 'Not Found')
    end

    it '500 page' do
      get :internal_server_error
      expect_helper('500', 'Internal Server Error')
    end
  end
end
