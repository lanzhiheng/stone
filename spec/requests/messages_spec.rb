# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Message Pages' do
  describe 'create messages' do
    it 'create data' do
      post messages_url, params: { message: { name: 'name', email: 'admin@example.com', content: 'hello world' } }

      expect(response.status).to eq 201
      expect(Message.count).to eq 1
      expect(Message.first.name).to eq 'name'
      expect(Message.first.email).to eq 'admin@example.com'
      expect(Message.first.content).to eq 'hello world'
    end

    it 'create data failed without field' do
      post messages_url, params: { message: { email: 'admin@example.com', content: 'hello world' } }

      expect(response.status).to eq 422
      expect(Message.count).to eq 0
    end
  end
end
