require 'spec_helper'

RSpec.describe Common::Domain::Model::Identity do
  let(:identity) { described_class.new subdomain: subdomain, uniq_value: uniq_value, created_at: created_at}

  let(:subdomain) { "some_subdomain" }
  let(:uniq_value) { "1234" }
  let(:created_at) { Common::Domain::Model::CreatedAt.new }

  describe "#to_s" do
    subject(:to_s) { identity.to_s }

    it { is_expected.to eq("#{subdomain}-#{uniq_value}-#{created_at}") }
  end
end
