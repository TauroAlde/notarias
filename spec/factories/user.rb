FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_name#{n}"}
    father_last_name "father_last_name"
    mother_last_name "mother_last_name"
    sequence(:email) { |n| "user#{n}@test.com" }
    sequence(:username) { |n| "username#{n}" }
    password "123456"
    password_confirmation "123456"

    trait :in_group do
      after(:create) do |user|
        group = create(:group)
        create(:user_group, group: group, user: user)
      end
    end
  end
end