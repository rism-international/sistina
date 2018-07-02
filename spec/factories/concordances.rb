FactoryBot.define do
  factory :concordance do
    title {Faker::TwinPeaks.quote}
    ccd0 {Faker::StarWars.quote}
  end
end
