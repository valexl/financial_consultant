require 'spec_helper'

RSpec.describe BalanceFactory do
  describe ".build" do
    subject(:build) { described_class.build(rub_value: rub_value, usd_value: usd_value, eur_value: eur_value) }
    let(:rub_value) { 0 }
    let(:usd_value) { 0 }
    let(:eur_value) { 0 }

    it { is_expected.to be_a(Balance) }
  end
end