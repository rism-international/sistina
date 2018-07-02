FactoryBot.define do
  factory :piece do
    current {Faker::Number.number(10)}
    done false
    concordance_id nil
  end
end
