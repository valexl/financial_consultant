require 'spec_helper'

RSpec.describe Admin::Application::Month::MonthApplicationService do
  let(:service) { described_class.new repository, producer }

  let(:repository) { Admin::Port::Adapter::Persistence::MemoryMonthRepository.new }
  let(:producer) { Admin::Port::Adapter::Messaging::Kafka::FakeAdminTopicProducer.new }

  describe "#start_month" do
    subject(:start_month) { service.start_month(command) }

    let(:command) { Admin::Application::Month::StartMonthCommand.new(year: 2022, month_number: 6) }

    it "creates a new month" do
      expect {
        start_month
      }.to change { repository.all_months.count }.by(1)
    end

    context "if month is already crated" do
      it "must not create a new record" do
        expect {
          start_month
        }.to avoid_changing { repository.all_months.count }
      end
    end

    it "publish events through producer" do
      raise 'Implement me'
    end
  end
end