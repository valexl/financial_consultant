require 'spec_helper'

RSpec.describe Balance do
  let(:balance) { described_class.new(cash: cash) }
  let(:cash) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(initial_value: rub_value),
      usd_money: money_creator.build_usd(initial_value: usd_value),
      eur_money: money_creator.build_eur(initial_value: eur_value)
    )
  end
  let(:money_creator) { MoneyCreator.new }
  let(:rub_value) { 0 }
  let(:usd_value) { 0 }
  let(:eur_value) { 0 }

  describe "#replenish" do
    subject(:replenish) { balance.replenish(money)}

    let(:money) do
      money_creator.build(currency: Currency::USD, initial_value: 1000)
    end

    it "increases cash value for the same as in money currency" do
      expect {
        replenish
      }.to change { cash.usd_money.value }.from(0).to(1000)
      .and avoid_changing { cash.rub_money.value }.from(0)
      .and avoid_changing { cash.eur_money.value }.from(0)
    end
  end
end