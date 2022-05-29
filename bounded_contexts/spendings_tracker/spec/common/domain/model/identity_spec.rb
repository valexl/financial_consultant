require 'spec_helper'

RSpec.describe Common::Domain::Model::Identity do
  let(:identity) { described_class.new subdomain: subdomain, uniq_value: uniq_value, created_at: created_at_value}

  let(:subdomain) { "some_subdomain" }
  let(:uniq_value) { "1234" }
  let(:created_at_value) { Common::Domain::Model::CreatedAt.new }

  describe "#to_s" do
    subject(:to_s) { identity.to_s }

    it { is_expected.to eq("#{subdomain}-#{uniq_value}-#{created_at_value}") }
  end

  describe "#created_at" do
    subject(:created_at) { identity.created_at }

    it { is_expected.to eq(created_at_value) }

    context "when there is no created_at" do
      let(:identity) { described_class.new subdomain: subdomain, uniq_value: uniq_value}

      it { is_expected.to be_a(Common::Domain::Model::CreatedAt) }
    end
  end
end
