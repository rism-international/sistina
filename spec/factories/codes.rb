FactoryBot.define do
  factory :code do
    cs { Faker::StarWars.droid }
    content { Faker::StarWars.call_squadron }
    t_ { Faker::StarWars.specie }
  end
end
