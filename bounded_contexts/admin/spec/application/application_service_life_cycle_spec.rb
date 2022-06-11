require 'spec_helper'

RSpec.describe Admin::Application::ApplicationServiceLifeCycle do
  let(:service) { described_class.new(producer: producer, event_store: event_store)  }
  let(:producer) { Admin::Port::Adapter::Messaging::Kafka::FakeAdminTopicProducer }
  let(:event_store) { Admin::Port::Adapter::Persistence::MemoryEventStore.new }
  let(:event) do
    Common::Domain::Model::DomainEvent.new id: "123", subdomain: "admin"
  end

  describe "#start" do
    subject(:start) { service.start }

    it "calls reset in DomainEventPublisher" do
      expect(Admin::Domain::Model::DomainEventPublisher).to receive(:reset).and_call_original
      start
    end

    it "subscribes to any changes in DomainEventPublisher" do
      expect(Admin::Domain::Model::DomainEventPublisher).to receive(:subscribe).with(service).and_call_original
      start
    end
  end

  describe "#handle_event" do
    subject(:handle_event) { service.handle_event(event) }

    it "saves event in event_store" do
      expect(event_store).to receive(:store_event).with(event)
      handle_event
    end
  end

  describe "#success" do
    subject(:success) { service.success }

    context "when there were some events" do
      before do
        event_store.store_event(event)
      end

      it "broadcasts events through producer" do
        expect(producer).to receive(:broadcast_events).with([event])
        success
      end
    end

    context "when there were no events" do
      before { event_store.rollback }

      it "doesn't broadcast anything" do
        expect(producer).not_to receive(:broadcast_events)
        success
      end
    end
  end

  describe "#rollback" do
    subject(:rollback) { service.rollback }

    context "when there were some events" do
      before do
        event_store.store_event(event)
      end

      it "doesn't broadcast anything" do
        expect(producer).not_to receive(:broadcast_events)
        rollback
      end

      it "cleans event store" do
        expect(event_store).to receive(:rollback)
        rollback
      end      
    end

    context "when there were no events" do
      it "doesn't broadcast anything" do
        expect(producer).not_to receive(:broadcast_events)
        rollback
      end

      it "cleans event store" do
        expect(event_store).to receive(:rollback)
        rollback
      end      
    end
  end
end