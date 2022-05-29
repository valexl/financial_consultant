require 'spec_helper'

RSpec.describe Application::Month::StartMonthCommand do
  subject(:command) do
    described_class.new(
      id: id,
      year: year_value,
      month_number: month_number_value
    )
  end

  let(:id) { "#{subdomain}-#{uniq_value}-#{created_at_time.to_r}" }
  let(:created_at_time) { Time.now }
  let(:subdomain) { 'admin' }
  let(:uniq_value) { '1234' }
  let(:year_value) { 2022 }
  let(:month_number_value) { 5 }

  describe '#identity' do
    subject(:identity) { command.identity }

    let(:expected_identity) do
      Common::Domain::Model::Identity.new(
        subdomain: subdomain,
        uniq_value: uniq_value,
        created_at: created_at
      )
    end
    let(:created_at) do
      Common::Domain::Model::CreatedAt.new(
        time: created_at_time
      )
    end

    it { is_expected.to eq(expected_identity) }
  end

  describe '#year' do
    subject(:year) { command.year }

    it { is_expected.to eq(year_value) }
  end

  describe '#month_number' do
    subject(:month_number) { command.month_number }

    it { is_expected.to eq(month_number_value) }
  end
end
