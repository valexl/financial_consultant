require 'spec_helper'

RSpec.describe Repositories::BalanceRepository do
  let(:builder)  { MoneyBuilder.new }
  let(:money_creator) { MoneyCreator.new(builder) }
  let(:balance) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: 0),
      usd_money: money_creator.build_usd(value: 0),
      eur_money: money_creator.build_eur(value: 0)
    )
    Balance.new(cash: cash, investments: [])
  end


  describe ".create" do
    subject(:create) { described_class.create(balance) }

    it "creates new record in db" do
      expect { create }.to change { DB[:balances].count }.by(1)
    end
  end

  describe ".fetch" do
    subject(:fetch) { described_class.fetch }

    it { is_expected.to be_a(Balance) }
  end

  describe ".save" do
    subject(:save) { described_class.save(balance) }

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
    before do 
      described_class.create(balance)
      balance.cash = new_cash
      balance.investments = investments
    end

    it "saves changes in db" do
      expect {
        save
      }.to change { described_class.fetch.rub_cash_only_value }
      .and change { described_class.fetch.usd_cash_only_value }
      .and change { described_class.fetch.eur_cash_only_value }
      .and change { described_class.fetch.investments }
    end

  end
end