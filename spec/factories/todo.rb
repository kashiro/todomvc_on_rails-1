FactoryBot.define do
  factory :todo do
    sequence(:title) { |n| "test todo #{n}" }
  end
  trait :completed do
    completed true
  end
end
