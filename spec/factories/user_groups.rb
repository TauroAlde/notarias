FactoryBot.define do
  factory :user_group do
    user_id { create(:user).id }
    group_id { create(:group).id }
  end
end
