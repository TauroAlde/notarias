require 'rails_helper'

RSpec.describe UserPreference, type: :model do
  
  describe "validations" do
    it { expect(build(:user_preference)).to be_valid }
    it { expect(build(:user_preference, user_id: nil)).to_not be_valid }
    it { expect(build(:user_preference, preference_id: nil)).to_not be_valid }
    it { expect(build(:user_preference, value: nil)).to_not be_valid }
  end

  describe "asociations" do
    it { should belong_to(:user) }
    it { should belong_to(:preference) }
  end

end
