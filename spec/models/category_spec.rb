require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'create category' do
    it 'without any fields' do
      Category.create
      expect(Category.count).to eq 0
    end

    it 'without key' do
      expect {
        create(:category, key: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Category.count).to eq 0
    end

    it 'without name' do
      expect {
        create(:category, name: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Category.count).to eq 0
    end

    it 'with key and name' do
      create(:category)
      expect(Category.count).to eq 1
    end
  end
end
