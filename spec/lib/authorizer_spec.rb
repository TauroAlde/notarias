require 'rails_helper'

RSpec.describe Authorizer, type: :model do
  RSpec.shared_examples "authorization allowed" do
    it { expect(subject.authorize(featurette, action)).to eql true }
    it { expect(subject.authorize!(featurette, action)).to eql true  }
    it { expect { subject.authorize!(featurette, action) }.not_to raise_error { Authorizer::AccessDenied } }
  end

  describe "With featurette_object permission" do
    let(:permission) { create(:permission, featurette_object: featurette, action: action, authorizable: authorizable) }

    subject { Authorizer.new(authorizable) }
    before { permission }

    context "For management action" do
      let(:action) { Authorizer::MANAGE }
      let(:authorizable) { create(:user) }
      let(:featurette) { "aresource" }

      it "returns true authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql true
      end
      it_behaves_like "authorization allowed"
    end

    context "For custom action" do
      let(:action) { "customaction" }
      let(:authorizable) { create(:user) }
      let(:featurette) { "aresource" }

      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
      it_behaves_like "authorization allowed"
    end
  end

  describe "With featurette polymorphic relation permission" do
    let(:permission) { create(:permission, featurette: featurette, action: action, authorizable: authorizable) }

    subject { Authorizer.new(authorizable) }
    before { permission }

    context "For management action" do
      let(:action) { Authorizer::MANAGE }
      let(:authorizable) { create(:user) }
      let(:featurette) { create(:user) }

      it "returns true authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql true
      end
      it_behaves_like "authorization allowed"
    end

    context "For custom action" do
      let(:action) { "customaction" }
      let(:authorizable) { create(:user) }
      let(:featurette) { create(:user) }

      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
      it_behaves_like "authorization allowed"
    end
  end

  describe "Authorizing authorizable collection class" do
    let(:permission) { create(:permission, featurette: featurette, action: action, authorizable: authorizable) }

    subject { Authorizer.new(authorizable) }
    before { permission }

    context "For management action" do
      let(:action) { Authorizer::MANAGE }
      let(:authorizable) { create(:user, :in_group).groups.first }
      let(:featurette) { create(:user) }

      it "returns true authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql true
      end
      it_behaves_like "authorization allowed"
    end

    context "For custom action" do
      let(:action) { "customaction" }
      let(:authorizable) { create(:user, :in_group).groups.first }
      let(:featurette) { create(:user) }

      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
      it_behaves_like "authorization allowed"
    end
  end
end
