FactoryGirl.define do
  factory :user do
    username { Faker::Internet.unique.user_name(5..10) }
    password 'test_testing'
    first_name { Faker::Name.first_name * 2 }
    second_name { Faker::Name.last_name * 2 }
    patronymic { Faker::Name.last_name * 2 }

    trait :teacher do
      is_teacher true
    end
  end
end
