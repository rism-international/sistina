FactoryBot.define do
  factory :unit do
    cs {Faker::StarWars.call_sign}
    comment0 {Faker::StarWars.quote}
    association :code
  end
end
