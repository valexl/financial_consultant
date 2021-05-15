require 'spec_helper'

RSpec.describe Repositories::BalanceRepository do
  describe ".initiate" do
    subject(:initiate) { described_class.initiate }

    it "creates new record in db" do
      expect { initiate }.to change { DB[:balances].count }.by(1)
    end
  end

  describe ".fetch" do
    subject(:fetch) { described_class.fetch }

    it { is_expected.to be_a(Balance) }
  end

  describe ".save" do
    subject(:save) { described_class.save(balance) }

    let(:balance) { described_class.fetch }
    let(:new_cash) do
      cash = Cash.new(
        rub_money: money_creator.build_rub(value: 100),
        usd_money: money_creator.build_usd(value: 1000),
        eur_money: money_creator.build_eur(value: 10000)
      )
    end
    let(:investments) do
      [
        Investments::ApartmentInvestment.new(
          name: "Test", 
          initial_price: money_creator.build_usd(value: 200),
          balance: balance
        )
      ]
    end
    let(:builder)  { MoneyBuilder.new }
    let(:money_creator) { MoneyCreator.new(builder) }

    before do 
      described_class.initiate
      balance.instance_variable_set(:@cash, new_cash)
      balance.instance_variable_set(:@investments, investments)
    end

    it "saves changes in db" do
      expect {
        save
      }.to change { described_class.fetch.rub_cash_only_value }
      .and change { described_class.fetch.usd_cash_only_value }
      .and change { described_class.fetch.eur_cash_only_value }
    end

  end
end