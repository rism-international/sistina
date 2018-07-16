FactoryBot.define do
  factory :part do
    nr {Faker::Number.number(10)}
    title {Faker::StarWars.planet}
    composer {Faker::StarWars.character}
    association :piece
  end
end
