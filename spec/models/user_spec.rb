require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    it {expect(create(:user)).to be_valid}
    it {expect(build(:user, email: nil)).to_not be_valid}
    it {expect(build(:user, password: nil)).to_not be_valid}
    it {expect(build(:user, password_confirmation: nil)).to be_valid}
  end

  describe "asociations" do
    it { should have_many(:procedures).class_name('Procedure').with_foreign_key('creator_user') }
    it { should have_many(:user_preference) }
  end

end