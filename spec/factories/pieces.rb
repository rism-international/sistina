FactoryBot.define do
  factory :piece do
    nr {Faker::Number.number(10)}
    cs {Faker::StarWars.droid}
    title {Faker::StarWars.call_sign}
    association :code
    #done false
    #code_id nil
  end
end
