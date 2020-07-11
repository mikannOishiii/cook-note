FactoryBot.define do
  factory :recipe do
    name { "MyString" }
    description { "MyString" }
    url { "" }
    image { nil }
    recipeYield { "2〜3人分" }
    cooktime { 10 }
    association :user
  end
end
