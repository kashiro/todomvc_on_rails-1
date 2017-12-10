FactoryBot.define do
  factory :todo do
    title 'test dodo'
  end
  trait :completed do
    completed true
  end
end
