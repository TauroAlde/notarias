FactoryBot.define do
  factory :permission do
    featurette_object "featurete object"
    featurette_type "preference name"
    # featurette
    user_id { create(:user).id }
    group_id { create(:group).id }
    permitted true
  end
end
