FactoryBot.define do
  factory :pokemon do
    name { Faker::Games::Pokemon.name }
    base_experience { rand(1..100) }
    height { rand(1..20) }
    weight { rand(1..20) }

    trait :with_type do
      after(:build) do |pokemon|
        pokemon.types << FactoryBot.create(:type)
      end
    end
  end
end
