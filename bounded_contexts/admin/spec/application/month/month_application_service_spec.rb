require 'spec_helper'

RSpec.describe Admin::Application::Month::MonthApplicationService do
  let(:service) { described_class.new repository: repository, producer: producer, event_store: event_store }

  let(:repository) { Admin::Port::Adapter::Persistence::MemoryMonthRepository.new }
  let(:producer) { Admin::Port::Adapter::Messaging::Kafka::FakeAdminTopicProducer }
  let(:event_store) { Admin::Port::Adapter::Persistence::MemoryEventStore.new }

  describe "#start_month" do
    subject(:start_month) { service.start_month(command) }

    let(:command) { Admin::Application::Month::StartMonthCommand.new(year: 2022, month_number: 6) }

    it "creates a new month" do
      expect {
        start_month
      }.to change { repository.all_months.count }.by(1)
    end

    xcontext "if month is already crated" do
      it "must not create a new record" do
        expect {
          start_month
        }.to avoid_changing { repository.all_months.count }
      end
    end

    it "publishes events through producer" do
      expect(producer).to receive(:broadcast_events).with([instance_of(Admin::Domain::Model::Month::MonthStarted)])
      start_month
    end

    context "when there is an error in repository during the process of saving" do
      before do
        allow(repository).to receive(:create) do
          raise 'Some error'
        end
      end
      
      it "doesn't publish events through producer" do
        expect(producer).not_to receive(:broadcast_events)
        start_month
      end
    end
  end
end