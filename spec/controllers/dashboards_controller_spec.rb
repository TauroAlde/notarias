require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do

  before(:each) do
    sign_in create(:user)
  end
  
  describe "GET index" do
    it "returns a successfull response" do
      get :index
      expect(response).to be_success
    end

    it "render index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
