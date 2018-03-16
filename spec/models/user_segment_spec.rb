require 'rails_helper'

RSpec.describe UserSegment, type: :model do
  describe "asociations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:segment) }
  end
end
