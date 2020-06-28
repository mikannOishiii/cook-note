FactoryBot.define do
  factory :recipe do
    name { "MyString" }
    description { "MyString" }
    url { "MyString" }
    image { "MyString" }
    recipeYield { "MyString" }
    cooktime { "MyString" }
    user { nil }
  end
end
