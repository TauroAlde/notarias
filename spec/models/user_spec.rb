require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    it {expect(build(:user)).to be_valid}
    it {expect(build(:user, email: nil)).to_not be_valid}
    it {expect(build(:user, password: nil)).to_not be_valid}
    it {expect(build(:user, password_confirmation: nil)).to be_valid}
  end

  describe "asociations" do
    it "has_many procedure" do
      assc = described_class.reflect_on_association(:procedures)
      expect(assc.macro).to eq :has_many
    end
  end

end