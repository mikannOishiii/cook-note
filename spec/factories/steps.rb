FactoryBot.define do
  factory :step do
    sequence(:body, "body_1")
    association :recipe
  end
end
