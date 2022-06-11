require 'spec_helper'

RSpec.describe Admin::Port::Adapter::Persistence::MemoryEventStore do
  let(:event_store) { described_class.new }
  let(:event) do
    Common::Domain::Model::DomainEvent.new id: "123", subdomain: "admin"
  end

  describe "#store_event" do
    subject(:store_event) { event_store.store_event(event) }
    it "adds event to collection" do
      expect {
        store_event
      }.to change { event_store.instance_variable_get(:@storage) }.to([event])
    end
  end

  describe "#new_events" do
    subject(:new_events) { event_store.new_events }

    context "when there is no added events" do
      it "returns all stored event" do
        expect(new_events).to eq([])
      end
    end

    context "when there was added event" do
      before { event_store.store_event(event) }
      
      it "returns stored event" do
        expect(new_events).to eq([event])
      end
    end
  end
end