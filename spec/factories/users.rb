FactoryBot.define do
  factory :user do
    name { "testuser" }
    email { "testuser@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
