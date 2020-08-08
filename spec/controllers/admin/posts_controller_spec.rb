# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:user) { create(:admin_user) }
  before { sign_in user }

  describe 'GET index' do
    let(:filters_sidebar) { page.find('#filters_sidebar_section') }
    it 'filter Name exists' do
      get :index
      expect(filters_sidebar).to have_css('label[for="q_title_contains"]', text: 'Title')
      expect(filters_sidebar).to have_css('label[for="q_category_id"]', text: 'Category')
    end
  end
end
