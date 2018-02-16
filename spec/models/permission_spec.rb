require 'rails_helper'

RSpec.describe Permission, type: :model do
  
  describe "validations" do
    it { expect(build(:permission, featurette: create(:preference))).to be_valid }
  end

  describe "asociations" do
    it { should belong_to(:featurette) }
    it { should belong_to(:user) }
    it { should belong_to(:group) }
    it { should have_many(:permission_tags) }
  end

end
