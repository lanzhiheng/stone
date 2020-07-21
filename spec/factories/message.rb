# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    email { 'MyString' }
    name { 'MyString' }
    content { 'MyText' }
  end
end
