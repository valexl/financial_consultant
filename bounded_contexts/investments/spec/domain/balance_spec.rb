require 'spec_helper'

RSpec.describe Balance do
  let(:balance) { described_class.new(cash: cash) }
  let(:cash) do
    money_creator = MoneyCreator.new(builder)
  
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: rub_value),
      usd_money: money_creator.build_usd(value: usd_value),
      eur_money: money_creator.build_eur(value: eur_value)
    )
  end
  let(:builder) { MoneyBuilder.new}
  let(:rub_value) { 0 }
  let(:usd_value) { 0 }
  let(:eur_value) { 0 }

  describe "#replenish" do
    subject(:replenish) { balance.replenish(money)}

    let(:money) do
      builder = MoneyBuilder.new
      builder.currency = Currency::USD
      builder.value = 1000
      builder.money_object
    end

    it "increases cash value for the same as in money currency" do
      expect {
        replenish
      }.to change { cash.usd_only_value }.from(0).to(1000)
      .and avoid_changing { cash.rub_only_value }.from(0)
      .and avoid_changing { cash.eur_only_value }.from(0)
    end
  end
end