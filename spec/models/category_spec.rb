# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  context 'create category' do
    it 'without any fields' do
      Category.create
      expect(Category.count).to eq 0
    end

    it 'without key' do
      expect do
        create(:category, key: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(Category.count).to eq 0
    end

    it 'without name' do
      expect do
        create(:category, name: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(Category.count).to eq 0
    end

    it 'with key and name' do
      create(:category)
      expect(Category.count).to eq 1
    end
  end
end
