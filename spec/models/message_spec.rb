# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  let(:message) { build(:message) }

  it 'email must exists' do
    message.email = nil
    expect do
      message.save!
    end.to raise_error(ActiveRecord::RecordInvalid)

    message.email = 'admin@example.com'
    expect(message.save).to be true
  end

  it 'name must exists' do
    message.name = nil
    expect do
      message.save!
    end.to raise_error(ActiveRecord::RecordInvalid)
    message.name = 'hello'
    expect(message.save).to be true
  end

  it 'content must exists' do
    message.content = nil
    expect do
      message.save!
    end.to raise_error(ActiveRecord::RecordInvalid)
    message.content = 'hello world.'
    expect(message.save).to be true
  end
end
