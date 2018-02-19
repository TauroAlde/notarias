FactoryBot.define do
  factory :user_group do
    user_id { create(:user) }
    group_id { create(:group) }
  end
end
