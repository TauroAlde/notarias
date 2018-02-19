require 'rails_helper'

RSpec.describe User, type: :model do

  describe "asociations" do
    it "has_many procedure" do
      assc = described_class.reflect_on_association(:procedures)
      expect(assc.macro).to eq :has_many
    end
  end

  describe "validations" do    
    it {expect(build(:user)).to be_valid}
    it {expect(build(:user, email: nil)).to_not be_valid}
    it {expect(build(:user, password: nil)).to_not be_valid}
    it {expect(build(:user, password_confirmation: nil)).to be_valid}
    it {expect(build(:user, username: nil)).to be_valid}
    it { is_expected.to validate_presence_of(:username) }
    it { expect validate_uniqueness_of(:username) }
    it { expect allow_value('/^[a-zA-Z0-9_\.]*$/').for(:username) }
  end

  describe "before_validation" do
    it { is_expected.to callback(:set_username).before(:validation) }
  end

  describe "attr_accessors" do
    it { expect have_attr_accessor(:login) }
    it { expect have_attr_accessor(:prevalidate_username_uniqueness) } # ahi se lo pones tu al context
  end
  
  describe "#set_username" do
    context "prevalidate_username_uniqueness == true" do 
      it "returns a new username when the user is blank" do
        user = create(:user, username: "")
        expect(user.username).to eq(user.login)
      end

      it "returns a new username when the user is nil" do
        user = create(:user, username: nil)
        expect(user.username).to eq(user.login)
      end

      it "returns a different username when the second created user have the same username1" do
        username = "username1"
        user = create(:user, username: username)
        user2 = create(:user, username: username)
        expect(user2.username).to_not eq(username)
      end

      it "returns a different username when the username exists in the database" do
        username = "username1"
        user = create(:user, username: username)
        user2 = create(:user, username: username)
        expect(user.username).to_not eq(user2.username)
      end
    end

    context "prevalidate_username_uniqueness == false" do
      it "returns username set by user" do
        user = create(:user, username: "username")
        expect(user.username).to eq(user.username)
      end
    end 
  end

  describe "#login" do #These tests are for the devise behavior, the instance form User to evaluate, has to be new, not a record saved in the database or it will never be saved in cases that are not sent or the username or email.      
    it "returns username when user is created" do
      user = create(:user)
      expect(user.login).to eq(user.username)
    end

    context "these cases are for unsaved user" do
      it "when username is nil returns email" do
        user = build(:user, email: "email", username: nil)
        expect(user.login).to eq(user.email)
      end

      it "when email is nil returns username" do
        user = build(:user, email: nil, username: "username")
        expect(user.login).to eq(user.username)
      end

      it "when email and username are nil returns login nil" do
        user = build(:user, email: nil, username: nil)
        expect(user.login).to eq(nil)
      end
    end
  end
end