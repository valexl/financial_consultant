require 'spec_helper'

RSpec.describe Admin::Port::Adapter::Messaging::Kafka::AdminTopicProducer do
  let(:producer) { described_class.new }
  let(:event) { Common::Domain::Model::DomainEvent.new id: "123", subdomain: "admin" }

  describe "#respond" do
    subject(:respond) { producer.respond(event) }

    it "calls respond_to with admin topic argument and event in hash format" do
      expect(producer).to receive(:respond_to).with(:admin, event.to_h)
      respond
    end
  end
end