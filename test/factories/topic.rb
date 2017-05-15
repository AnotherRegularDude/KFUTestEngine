FactoryGirl.define do
  factory :topic do
    title { Faker::Lorem.unique.words.join.truncate(40) }
    short_description { Faker::Lorem.sentences }
    questions_per_test { Faker::Number.between(5, 10) }

    factory :topic_with_materials do
      transient do
        materials_count 3
      end

      after(:create) do |topic, evaulator|
        create_list(:material, evaulator.materials_count, topic: topic)
      end
    end
  end
end
