# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController do
  describe 'post method' do
    it 'create data' do
      post :create, params: { name: 'name', email: 'admin@example.com', content: 'hello world' }

      expect(response.code).to eq '200'
      expect(response.body).to eq ({ message: 'success' }).to_json
      expect(Message.count).to eq 1
      expect(Message.first.name).to eq 'name'
      expect(Message.first.email).to eq 'admin@example.com'
      expect(Message.first.content).to eq 'hello world'
    end

    it 'create data failed without field' do
      post :create, params: { email: 'admin@example.com', content: 'hello world' }

      expect(response.code).to eq '400'
      expect(response.body).to eq ({ message: 'request failed' }).to_json
      expect(Message.count).to eq 0
    end
  end
end
