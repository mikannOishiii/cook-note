FactoryBot.define do
  factory :user do
    name { "testuser" }
    email { "testuser@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }

    trait :invalid do
      name { nil }
    end

    factory :other_user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
    end
  end
end
