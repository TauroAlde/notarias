require 'rails_helper'

RSpec.describe Authorizer, type: :model do
  shared_examples "Authorizing action" do
    it { expect(subject.authorize(featurette, action)).to eql true }
    it { expect(subject.authorize!(featurette, action)).to eql true  }
    it { expect { subject.authorize!(featurette, action) }.not_to raise_error { Authorizer::AccessDenied } }
  end

  shared_examples "Denying action" do
    let(:permission) { create(:permission, featurette_object: featurette, action: action, authorizable: authorizable, permitted: false) }
    context "User permission restricted" do
      it { expect(subject.authorize(featurette, action)).to eql false }
      it { expect { subject.authorize!(featurette, action) }.to raise_error { Authorizer::AccessDenied } }
      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
    end

    context "User group restricted" do
      include_context "Authorizing collection class"

      it { expect(subject.authorize(featurette, action)).to eql false }
      it { expect { subject.authorize!(featurette, action) }.to raise_error { Authorizer::AccessDenied } }
      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
    end
  end

  shared_examples "Authorizing collection class" do
    let(:authorizable) { create(:user, :in_group).groups.first }
  end

  describe "With featurette_object" do
    let(:permission) { create(:permission, featurette_object: featurette, action: action, authorizable: authorizable) }

    subject { Authorizer.new(authorizable) }
    before { permission }

    shared_context "Overlapping permissions" do
      let(:user) { create(:user, :in_group) }
      let(:group) { user.groups.first }

      context "For user group permitted and user denied" do
        let(:permission) { create(:permission, featurette_object: featurette, action: action, authorizable: user, permitted: false) }
        before { create(:permission, featurette_object: featurette, action: action, authorizable: group, permitted: true) }

        context "Authorizing user group" do
          let(:authorizable) { group }
          it { expect(subject.authorize(featurette, action)).to eql true }
          it { expect { subject.authorize!(featurette, action) }.not_to raise_error { Authorizer::AccessDenied } }
        end

        context "Authorizing user" do
          let(:authorizable) { user }
          it { expect(subject.authorize(featurette, action)).to eql false }
          it { expect { subject.authorize!(featurette, action) }.to raise_error { Authorizer::AccessDenied } }
        end
      end

      context "For user group denied and user permitted" do
        let(:permission) { create(:permission, featurette_object: featurette, action: action, authorizable: user, permitted: true) }
        before { create(:permission, featurette_object: featurette, action: action, authorizable: group, permitted: false) }

        context "Authorizing user group" do
          let(:authorizable) { group }
          it { expect(subject.authorize(featurette, action)).to eql false }
          it { expect { subject.authorize!(featurette, action) }.to raise_error { Authorizer::AccessDenied } }
        end

        context "Authorizing user" do
          let(:authorizable) { user }
          it { expect(subject.authorize(featurette, action)).to eql true }
          it { expect { subject.authorize!(featurette, action) }.not_to raise_error { Authorizer::AccessDenied } }
        end
      end
    end

    context "For management action" do
      let(:action) { Authorizer::MANAGE }
      let(:authorizable) { create(:user) }
      let(:featurette) { "aresource" }

      it "returns true authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql true
      end
      it_behaves_like "Authorizing action"
      it_behaves_like "Denying action" do
        it_behaves_like "Overlapping permissions"
      end
      it_behaves_like "Authorizing collection class" do
        it_behaves_like "Authorizing action"
        it "returns true authorizing management action by default" do
          permission
          expect(subject.authorize(featurette)).to eql true
        end
      end
    end

    context "For custom action" do
      let(:action) { "customaction" }
      let(:authorizable) { create(:user) }
      let(:featurette) { "aresource" }

      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
      it_behaves_like "Authorizing action"
      it_behaves_like "Denying action" do
        it_behaves_like "Overlapping permissions"
      end
      it_behaves_like "Authorizing collection class" do
        it_behaves_like "Authorizing action"
        it "returns false authorizing management action by default" do
          permission
          expect(subject.authorize(featurette)).to eql false
        end
      end
    end
  end

  describe "With featurette polymorphic relation permission" do
    let(:permission) { create(:permission, featurette: featurette, action: action, authorizable: authorizable) }
    let(:featurette) { create(:user) }
    subject { Authorizer.new(authorizable) }
    before { permission }

    shared_context "Overlapping permissions" do
      let(:user) { create(:user, :in_group) }
      let(:group) { user.groups.first }

      context "For user group permitted and user denied" do
        let(:permission) { create(:permission, featurette: featurette, action: action, authorizable: user, permitted: false) }
        before { create(:permission, featurette: featurette, action: action, authorizable: group, permitted: true) }

        context "Authorizing user group" do
          let(:authorizable) { group }
          it { expect(subject.authorize(featurette, action)).to eql true }
          it { expect { subject.authorize!(featurette, action) }.not_to raise_error { Authorizer::AccessDenied } }
        end

        context "Authorizing user" do
          let(:authorizable) { user }
          it { expect(subject.authorize(featurette, action)).to eql false }
          it { expect { subject.authorize!(featurette, action) }.to raise_error { Authorizer::AccessDenied } }
        end
      end

      context "For user group denied and user permitted" do
        let(:permission) { create(:permission, featurette: featurette, action: action, authorizable: user, permitted: true) }
        before { create(:permission, featurette: featurette, action: action, authorizable: group, permitted: false) }

        context "Authorizing user group" do
          let(:authorizable) { group }
          it { expect(subject.authorize(featurette, action)).to eql false }
          it { expect { subject.authorize!(featurette, action) }.to raise_error { Authorizer::AccessDenied } }
        end

        context "Authorizing user" do
          let(:authorizable) { user }
          it { expect(subject.authorize(featurette, action)).to eql true }
          it { expect { subject.authorize!(featurette, action) }.not_to raise_error { Authorizer::AccessDenied } }
        end
      end
    end

    context "For management action" do
      let(:action) { Authorizer::MANAGE }
      let(:authorizable) { create(:user) }

      it "returns true authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql true
      end
      it_behaves_like "Authorizing action"
      it_behaves_like "Denying action" do
        it_behaves_like "Overlapping permissions"
      end

      it_behaves_like "Authorizing collection class" do
        it_behaves_like "Authorizing action"
        it "returns true authorizing management action by default" do
          permission
          expect(subject.authorize(featurette)).to eql true
        end
      end
    end

    context "For custom action" do
      let(:action) { "customaction" }
      let(:authorizable) { create(:user) }

      it "returns false authorizing management action by default" do
        permission
        expect(subject.authorize(featurette)).to eql false
      end
      it_behaves_like "Authorizing action"
      it_behaves_like "Denying action" do
        it_behaves_like "Overlapping permissions"
      end
      it_behaves_like "Authorizing collection class" do
        it_behaves_like "Authorizing action"
        it "returns false authorizing management action by default" do
          permission
          expect(subject.authorize(featurette)).to eql false
        end
      end
    end
  end
end
