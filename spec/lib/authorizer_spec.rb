require 'rails_helper'

RSpec.describe Authorizer, type: :model do
  RSpec.shared_examples "authorization allowed" do

    before { permission }
    subject { Authorizer.new(authorizable) }

    it { expect(subject.authorize(featurette)).to eql true }
    it { expect(subject.authorize!(featurette)).to eql true  }
    it { expect { subject.authorize!(featurette) }.not_to raise_error { Authorizer::AccessDenied } }
    it "authorizes action" do 
      expect(subject.authorize(featurette, action)).to eql true
    end
  end

  describe "With featurette_object permission" do

    context "For management action" do
      it_behaves_like "authorization allowed" do
        let(:action) { Authorizer::MANAGE }
        let(:authorizable) { create(:user) }
        let(:featurette) { "aresource" }
        let(:permission) { create(:permission, featurette_object: featurette, action: action, authorizable: authorizable) }
      end
    end

    #context "For custom action" do
    #  let(:authorizable) { create(:user) }
    #  before { create(:permission, featurette_object: "aresource", action: "custom_action", authorizable: authorizable) }
    #  
    #  it_behaves_like "authorization allowed"
    #end

  end

  describe "With featurette relation permisison" do
  end
end
