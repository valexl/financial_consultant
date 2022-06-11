require 'spec_helper'

RSpec.describe Common::Domain::Model::DomainEvent do
  let(:event) { described_class.new id: "123", subdomain: "admin" }

  describe '#id' do
    subject(:id) { event.id }

    it { is_expected.to eq("123") }
  end

  describe '#subdomain' do
    subject(:subdomain) { "admin" }

    it { is_expected.to eq("admin") }
  end

  describe '#version' do
    subject(:version) { event.version }

    it { is_expected.to eq("1.0") }
  end

  describe '#occurred_on' do
    subject(:occurred_on) { event.occurred_on }

    it { is_expected.to be_a(Common::Domain::Model::CreatedAt) }
  end

  describe "#to_h" do
    subject(:to_h) { event.to_h }

    let(:expected_data) do
      {
        id: event.id,
        event_name: event.class.name.underscore,
        occurred_on: {
          time: event.occurred_on.time
        },
        subdomain: event.subdomain,
        version: event.version
      }
    end

    it "returns default value + adds info about event" do
      expect(to_h).to eq(expected_data)
    end
  end
end
