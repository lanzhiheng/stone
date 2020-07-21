# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :post do
    title { 'post title' }
    body { 'post body' }
    slug { 'post-slug' }
    excerpt { 'excerpt' }
    category
  end
end
