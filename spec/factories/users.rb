FactoryBot.define do
  factory :user do
    name { "testuser" }
    email { "test@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    activated { true }
    activated_at { Time.zone.now }

    trait :invalid do
      name { nil }
    end

    factory :other_user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
    end
  end
end
