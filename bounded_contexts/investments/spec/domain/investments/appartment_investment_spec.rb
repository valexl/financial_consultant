require 'spec_helper'

RSpec.describe Investments::ApartmentInvestment do
  let(:investment) { described_class.new(name: "test", initial_price: price, balance: balance) }
  let(:balance) { Balance.new(cash: cash) }
  let(:builder)  { MoneyBuilder.new }
  let(:money_creator) { MoneyCreator.new(builder) }
  let(:cash) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: rub_value),
      usd_money: money_creator.build_usd(value: usd_value),
      eur_money: money_creator.build_eur(value: eur_value)
    )
  end

  let(:rub_value) { 0 }
  let(:usd_value) { 0 }
  let(:eur_value) { 0 }

  describe "#open" do
    subject(:open) { investment.open }

    let(:price) do
      money_creator.build_usd(value: 10_000)
    end

    context "when there is no enough cash" do
      let(:usd_value) { 0 }

      it "keeps investment in pending state" do
        expect { open }.to avoid_changing { investment.opened? }.from(false)
      end

      it "keeps balance cash on the same value" do
        expect { open }.to avoid_changing { balance.cash.value(Currency::USD) }
      end
    end

    context "when there is enough cash" do
      let(:usd_value) { 10_000 }

      it "opens investment" do
        expect { open }.to change { investment.opened? }.from(false).to(true)
      end

      it "changes balance cash to the investment price value" do
        expect { open }.to change { balance.cash.value(Currency::USD) }.to(0)
      end
    end
  end

  describe "#close" do
    subject(:close) { investment.close }

    let(:usd_value) { 10_000 }
    let(:price) do
      money_creator.build_usd(value: usd_value)
    end

    before do
      investment.open
    end

    it "closes investment" do
      expect { close }.to change { investment.closed? }.to(true)
    end

    it "changes balance cash to the investment price value" do
      expect { close }.to change { balance.cash.value(Currency::USD) }.to(usd_value)
    end
  end
end