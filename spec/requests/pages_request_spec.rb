# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'extra pages' do
  it 'Can visit the robots.txt file' do
    get '/robots.txt'
    expect(response.code).to eq '200'
  end
end
