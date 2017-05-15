FactoryGirl.define do
  factory :material do
    short_description { Faker::Lorem.paragraph.truncate(255) }
    text_in_markdown { '### Header' + "\n" + Faker::Lorem.paragraph(7) }
    topic

    trait :with_rand_topic do
      topic { create(:topic) }
    end
  end
end
