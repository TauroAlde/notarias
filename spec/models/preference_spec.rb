require 'rails_helper'

RSpec.describe Preference, type: :model do

  describe "validations" do
    it { expect(build(:preference)).to be_valid }
    it { expect(build(:preference, name: nil)).to_not be_valid }
    it { expect(build(:preference, default_values: nil)).to_not be_valid }
    it { expect(build(:preference, field_type: nil)).to_not be_valid }
  end

  describe "define_enum_for" do
    it { should define_enum_for(:field_type) }
    it do
      should define_enum_for(:field_type).
        with([:text, :textarea, :number, :select_field, :checkbox, :radio, :date, :email, :password])
    end
  end

  describe "asociations" do
    it { should have_many(:user_preferences) }
    it { should have_many(:users).through(:user_preferences) }
  end

end
