require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @group1 = create(:group, name: "group name 1")
    @group2 = create(:group, name: "group name 2")
    @user_group = create(:user_group, user_id: @user1.id, group_id: @group1.id)
  end

  describe "validations" do
    it { expect(build(:user_group)).to be_valid }
    it { expect(build(:user_group, user_id: nil)).to_not be_valid }
    it { expect(build(:user_group, group_id: nil)).to_not be_valid }
    it { expect(build(:user_group, user_id: @user1.id, group_id: @group1.id)).to_not be_valid }
    it { expect(build(:user_group, user_id: @user2.id, group_id: @group2.id)).to be_valid }
    it { should validate_uniqueness_of(:user_id).scoped_to(:group_id)  }
    it { should validate_uniqueness_of(:group_id).scoped_to(:user_id)  }
  end

  describe "asociations" do
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end

end
