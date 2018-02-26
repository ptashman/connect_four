FactoryBot.define do
  factory :player do
    sequence(:id)
    name "John"
    number 1
    computer false
  end
end
