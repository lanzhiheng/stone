FactoryBot.define do
  factory :category do
    key { 'category_key' }
    name { '分类' }

    trait :blog do
      name { '博客' }
      key { 'blogs' }
    end

    trait :translation do
      name { '翻译' }
      key { 'translations' }
    end
  end
end
