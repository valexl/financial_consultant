require 'spec_helper'

RSpec.describe Admin::Domain::Model::DomainRegistry do
  describe ".start_month_service" do
    subject(:start_month_service) { described_class.start_month_service }

    it { is_expected.to be_a(Admin::Domain::Model::Month::StartMonthService) }
  end
end