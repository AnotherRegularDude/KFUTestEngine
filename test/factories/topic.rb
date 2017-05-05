FactoryGirl.define do
  factory :topic do
    title { Faker::Name.title }
    short_description { Faker::Lorem.sentences }
    questions_per_test { Faker::Number.between(5, 10) }
  end
end
