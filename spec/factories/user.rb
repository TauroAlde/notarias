FactoryBot.define do
  factory :user do
    sequence(:names) { |n| "user_name#{n}"}
    father_last_name "father_last_name"
    mother_last_name "mother_last_name"
    sequence(:email) { |n| "user#{n}@test.com" }
    password "123456"
    password_confirmation "123456"
  end
end