FactoryBot.define do
  factory :type do
    name { Faker::Types.rb_string }
  end
end
