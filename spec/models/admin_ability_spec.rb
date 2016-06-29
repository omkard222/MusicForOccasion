require 'rails_helper'

describe AdminAbility do
  context '#initialize' do
    let(:admin_master) { build(:admin) }
    let(:admin_admin) { build(:admin, role: 'Admin') }
    it 'with role "Master Admin"' do
      expect_any_instance_of(AdminAbility).to receive(:can)
      .with(:access, :rails_admin)
      expect_any_instance_of(AdminAbility).to receive(:can)
      .with(:manage, :all)
      AdminAbility.new(admin_master)
    end

    it 'with role "Master Admin"' do
      expect_any_instance_of(AdminAbility).to receive(:can)
      .with(:access, :rails_admin)
      expect_any_instance_of(AdminAbility).to receive(:can)
      .with(:manage, :all)
      expect_any_instance_of(AdminAbility).to receive(:cannot)
      .with(:read, Admin)
      AdminAbility.new(admin_admin)
    end


  end
end
