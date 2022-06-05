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
end
