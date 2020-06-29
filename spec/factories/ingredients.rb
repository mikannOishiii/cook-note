FactoryBot.define do
  factory :ingredient do
    name { "砂糖" }
    quantity_amount { "大さじ3" }
    association :recipe
  end
end
