require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "validations" do
    before do
      @group = create(:group)
    end
    subject { @group }
    it { should validate_uniqueness_of(:name) }
    it { expect(build(:group, name: "other group name")).to be_valid }
    it { expect(build(:group)).to_not be_valid }
  end
  describe "asociations" do
    it { should have_many(:permissions) }
    it { should have_many(:user_groups) }
    it { should have_many(:users).through(:user_groups) }
  end
end
