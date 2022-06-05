require 'spec_helper'

RSpec.describe Admin::Domain::Model::DomainEventPublisher do

  describe ".publish" do
    subject(:publish) { described_class.publish(event) }

    before { described_class.reset }

    class SomethingHappened < Common::Domain::Model::DomainEvent; end
    class SomethingWeirdHappened < Common::Domain::Model::DomainEvent; end
    
    context "when subscriber is subscribed to SomethingHappened event" do
      class SomethingHappenedSubscriber
        def handle_event(event)
          # do nothing
        end

        def subscribed_to_event_type
          SomethingHappened
        end
      end
      let(:subscriber) { SomethingHappenedSubscriber.new }

      before do
        described_class.subscribe(subscriber)
      end

      context "and SomethingHappened is publishing" do
        let(:event) { SomethingHappened.new id: '1234', subdomain: "admin" }
        
        it "calls subscriber handle_event method" do
          expect(subscriber).to receive(:handle_event).with(event)
          publish
        end
      end

      context "and SomethingWeirdHappened is publishing" do
        let(:event) { SomethingWeirdHappened.new id: '1234', subdomain: "admin" }

        it "calls subscriber handle_event method" do
          expect(subscriber).not_to receive(:handle_event)
          publish
        end
      end
    end

    context "when subscriber is subscribed to DomainEvent event" do
      class DomainEventSubscriber
        def handle_event(event)
          # do nothing
        end

        def subscribed_to_event_type
          Common::Domain::Model::DomainEvent
        end
      end
      let(:subscriber) do 
        DomainEventSubscriber.new
      end

      before do
        described_class.subscribe(subscriber)
      end

      context "and SomethingHappened is publishing" do
        let(:event) { SomethingHappened.new id: '1234', subdomain: "admin" }
        
        it "calls subscriber handle_event method" do
          expect(subscriber).to receive(:handle_event).with(event)
          publish
        end
      end

      context "and SomethingWeirdHappened is publishing" do
        let(:event) { SomethingWeirdHappened.new id: '1234', subdomain: "admin" }

        it "calls subscriber handle_event method" do
          expect(subscriber).to receive(:handle_event).with(event)
          publish
        end
      end
    end
  end
end