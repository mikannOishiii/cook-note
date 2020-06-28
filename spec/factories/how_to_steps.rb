FactoryBot.define do
  factory :how_to_step do
    sequence(:sort_order, 1) { n }
    body { "hogehogehoge" }
    association :recipe
  end
end
