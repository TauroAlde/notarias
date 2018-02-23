FactoryBot.define do
  factory :user_preference do
    user_id { create(:user).id }
    preference_id { create(:preference).id }
    value "value"
  end
end
