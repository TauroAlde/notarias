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
    it {expect(build(:user, username: nil)).to_not be_valid}
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
    # y antes de los contextos describes los comportamientos por default
    # la cosa con este metodo es que si el campo viene false, el comportamiento por default
    # es el que sucede, entonces el bloque de context tiens dos opciones
    # o lo quitas y pones aqui el comportamiento por default
    # etc
    # o pasas todos los comportamientos por default al context
    # ahora regresando al nombrado
    context "miatrubitovirtual == true" do # no me acuerdo como se llama el campo
      # aca ya van entonces los its de que pasa cuando es true
      it "returns username set by user" do

        expected_username = "username1"
        user = create(:user, username: expected_username)
        expect(user.username).to eq(expected_username)
      end
    end

    context "miatributovirtual == false" do
      # que pasa cuando es false, espera vino alguien
      it "comportamiento por default" do
      end
    end 

    it "expect a different username" do
      expect_username = create(:user, username: "")
      expect(expect_username.username).to eq("user_name1father_last_namemother_last_name")
    end

    it "expect a change the username" do
      expect_username = create(:user, username: "user_name1father_last_namemother_last_name")
      expect_username2 = create(:user, username: "user_name1father_last_namemother_last_name")
      expect(expect_username2.username).to_not eq("user_name1father_last_namemother_last_name")
    end
  end

  describe "#login" do
    context do
      before(:each) do
        @user = create(:user)
      end
      
      it "returns username" do
        expect(@user.login).to eq(@user.username)
      end

      it "returns email" do
        user = User.new(email: "el email")
        user.login
        expect(@user.login).to eq(@user.email)
      end
    end
  end

end