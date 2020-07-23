# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    email { 'hello@example.com' }
    password { 'random' }
  end
end
