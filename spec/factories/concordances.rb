FactoryBot.define do
  factory :concordance do
    nr {Faker::Number.number(10)}
    ccd0 {Faker::StarWars.quote}
    title {Faker::StarWars.planet}
#    done false
    association :piece
  end
end
