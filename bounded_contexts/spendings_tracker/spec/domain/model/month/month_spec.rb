require 'spec_helper'

RSpec.describe Domain::Model::Month::Month do
  subject(:month) { described_class.new id: identity, year: year_value, month_number: month_number_value }

  let(:identity) { Common::Domain::Model::Identity.new subdomain: 'admin', uniq_value: '1234' }
  let(:year_value) { 2022 }
  let(:month_number_value) { 5 }

  describe '#id' do
    subject(:id) { month.id }

    it { is_expected.to be_a(Common::Domain::Model::Identity) }
  end

  describe '#year' do
    subject(:year) { month.year }

    it { is_expected.to eq year_value }
  end

  describe '#month_number' do
    subject(:month_number) { month.month_number }

    it { is_expected.to eq month_number_value }
  end
end
