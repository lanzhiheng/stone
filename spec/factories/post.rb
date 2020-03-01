# This will guess the User class
FactoryBot.define do
  factory :post do
    title { 'post title' }
    body { 'post body' }
    slug { 'post-slug' }
    category
  end
end
