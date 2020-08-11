# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'sidebar link' do
    def create_categories
      create(:category, :blog)
      create(:category, :book)
    end

    it 'navbar link' do
      expect(helper.navbar).to have_tag('a', count: 3)
      create_categories
      expect(helper.navbar).to have_tag('a', count: 5)
    end

    it 'social link' do
      expect(helper.social).to have_tag('a', count: 5)
    end
  end
end
