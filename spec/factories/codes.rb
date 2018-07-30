FactoryBot.define do
  factory :code do
    cs { Faker::Number.number(20) }
    content { Faker::StarWars.call_squadron }
    t_ { Faker::StarWars.specie }
  end
end
