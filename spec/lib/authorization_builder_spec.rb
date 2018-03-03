require 'rails_helper'

RSpec.describe AuthorizationBuilder, type: :model do

  it { expect(subject).to validate_presence_of(:authorizable) }
  it { expect(subject).to validate_presence_of(:resource) }
  it { expect(subject).to validate_presence_of(:action) }

  describe "For User" do
    let(:authorizable) { create(:user) }
    subject { AuthorizationBuilder.new(authorizable: authorizable, resource: resource) }

    context "With fueature object" do
      let(:resource) { create(:user) }

      it "creates a new permission" do
        expect { subject.save }.to change { Permission.count }.from(0).to(1)
      end

      it "sets read action as default" do
        subject.save
        expect(subject.permission.action).to eql AuthorizationBuilder::DEFAULT_ACTION
      end

      it "sets featurette relationship" do
        subject.save
        expect(subject.permission.featurette).to eql resource
      end

      it "fails to duplicate permission" do
        subject.save
        expect { AuthorizationBuilder.new(authorizable: authorizable, resource: resource).save }.
          not_to change { Permission.count }
      end
    end

    context "With fueature resource" do
      let(:resource) { "A resource" }

      it "creates a new permission" do
        expect { subject.save }.to change { Permission.count }.from(0).to(1)
      end

      it "sets read action as default" do
        subject.save
        expect(subject.permission.action).to eql AuthorizationBuilder::DEFAULT_ACTION
      end

      it "sets featurette relationship" do
        subject.save
        expect(subject.permission.featurette_object).to eql resource
      end

      it "fails to duplicate permission" do
        subject.save
        expect { AuthorizationBuilder.new(authorizable: authorizable, resource: resource).save }.
          not_to change { Permission.count }
      end
    end
  end

  describe "For UserGroup" do
    let(:authorizable) { create(:user, :in_group).groups.first }
    subject { AuthorizationBuilder.new(authorizable: authorizable, resource: resource) }

    context "With fueature object" do
       let(:resource) { create(:user) }
       it "creates a new permission" do
         expect { subject.save }.to change { Permission.count }.from(0).to(1)
       end

       it "sets read action as default" do
         subject.save
         expect(subject.permission.action).to eql AuthorizationBuilder::DEFAULT_ACTION
       end

       it "sets featurette relationship" do
         subject.save
         expect(subject.permission.featurette).to eql resource
       end

       it "fails to duplicate permission" do
         subject.save
         expect { AuthorizationBuilder.new(authorizable: authorizable, resource: resource).save }.
           not_to change { Permission.count }
       end
    end

    context "With fueature resource" do
      let(:resource) { "A resource" }

      it "creates a new permission" do
        expect { subject.save }.to change { Permission.count }.from(0).to(1)
      end

      it "sets read action as default" do
        subject.save
        expect(subject.permission.action).to eql AuthorizationBuilder::DEFAULT_ACTION
      end

      it "sets featurette relationship" do
        subject.save
        expect(subject.permission.featurette_object).to eql resource
      end

      it "fails to duplicate permission" do
        subject.save
        expect { AuthorizationBuilder.new(authorizable: authorizable, resource: resource).save }.
          not_to change { Permission.count }
      end
    end
  end
end
