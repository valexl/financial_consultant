require 'spec_helper'

RSpec.describe Admin::Domain::Model::Month::StartMonthService do
  let(:service) { described_class.new }

  describe "#call" do
    subject(:call) { service.call(year: year, month_number: month_number) }

    let(:year) { 2022 }
    let(:month_number) { 6 }

    it { is_expected.to be_a(Admin::Domain::Model::Month::Month) }

    it "publishes MonthStarted" do
      expect(Admin::Domain::Model::DomainEventPublisher).to receive(:publish).with(an_instance_of(Admin::Domain::Model::Month::MonthStarted))
      call
    end
  end
end