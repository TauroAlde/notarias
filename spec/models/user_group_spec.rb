require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  
  describe "validations" do
    it { expect(create(:user_group, user: create(:user), group: create(:group))).to be_valid }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:group_id) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:group_id)  }
    it { is_expected.to validate_uniqueness_of(:group_id).scoped_to(:user_id)  }
  end

  describe "asociations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:group) }
  end

end
