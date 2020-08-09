# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  let!(:category) { build(:category) }

  context 'create category' do
    it 'without key' do
      category.key = nil
      expect do
        category.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'without name' do
      category.name = nil
      expect do
        category.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'with key and name' do
      create(:category)
      expect(Category.count).to eq 1
    end

    it 'should not contain duplicated key' do
      create(:category)
      expect do
        create(:category)
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Key has already been taken')
    end

    it 'key with unique index' do
      category.save!
      ca = create(:category, key: 'new_key')

      expect do
        ca.update_attribute('key', category.key) # skip application validation
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
