FactoryBot.define do
  factory :permission do
    authorizable { create(:user) }
    permitted true

    trait :authorizable_group do
      authorizable { create(:user_group) }
    end

    trait :not_permitted do
      permitted false
    end
  end
end
