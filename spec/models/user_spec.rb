require 'spec_helper'

describe User do

  it { should allow_mass_assignment_of :email }
  it { should allow_mass_assignment_of :password_confirmation }
  it { should allow_mass_assignment_of :password }
  it { should callback(:encrypt_password).before(:save) }
  it { should validate_confirmation_of :password }
  it { should validate_presence_of :password }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }

  let(:user) { build(:user) }

  context "create new" do
    it "can be created" do
      expect(user).to be_an_instance_of User
    end

  end
end
