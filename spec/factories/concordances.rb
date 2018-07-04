FactoryBot.define do
  factory :concordance do
    nr {Faker::Number.number(10)}
    ccd0 {Faker::StarWars.quote}
    done false
    piece_id nil
  end
end
