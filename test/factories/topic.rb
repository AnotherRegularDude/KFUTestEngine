FactoryGirl.define do
  factory :topic do
    title { Faker::Lorem.unique.word.truncate(40) }
    short_description { Faker::Lorem.sentences }
    questions_per_test { Faker::Number.between(5, 10) }
  end
end
