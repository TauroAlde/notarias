require 'rails_helper'

RSpec.describe Permission, type: :model do

  describe "asociations" do
    it { is_expected.to belong_to(:featurette) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:group) }
    it { is_expected.to have_many(:permission_tags) }
  end

end
