require 'spec_helper'

RSpec.describe Repositories::BalanceRepository do
  let(:money_creator) { MoneyCreator.new }
  let(:balance) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(initial_value: 0),
      usd_money: money_creator.build_usd(initial_value: 0),
      eur_money: money_creator.build_eur(initial_value: 0)
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

    before do
      described_class.create(balance)
    end

    it { is_expected.to be_a(Balance) }
  end

  describe ".save" do
    subject(:save) { described_class.save(balance) }

    let(:new_cash) do
      cash = Cash.new(
        rub_money: money_creator.build_rub(initial_value: 100),
        usd_money: money_creator.build_usd(initial_value: 1000),
        eur_money: money_creator.build_eur(initial_value: 10000)
      )
    end
    let(:investments) do
      [
        Investments::ApartmentInvestment.new(
          name: "Test", 
          price: Investments::Price.new(currency: Currency::USD, value: 200),
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
      }.to change { described_class.fetch.cash_rub_money.value }
      .and change { described_class.fetch.cash_usd_money.value }
      .and change { described_class.fetch.cash_eur_money.value }
      .and change { described_class.fetch.investments }
    end

    context "several children income" do
      let(:new_cash) do
        cash = Cash.new(
          rub_money: money_creator.build_rub(initial_value: 100, income: 10, income_of_income: 1, income_of_income_of_income: 0.1),
          usd_money: money_creator.build_usd(initial_value: 1000, income: 100, income_of_income: 10, income_of_income_of_income: 1),
          eur_money: money_creator.build_eur(initial_value: 10000, income: 1000, income_of_income: 100, income_of_income_of_income: 10)
        )
      end

      it "saves changes in db" do
        expect {
          save
        }.to change { described_class.fetch.cash_rub_money.value }
        .and change { described_class.fetch.cash_usd_money.value }
        .and change { described_class.fetch.cash_eur_money.value }
        .and change { described_class.fetch.investments }
      end

      it "saves info about income" do
        save
        cash = described_class.fetch.cash
        expect(cash.rub_money.value).to eq(111.1)
        expect(cash.rub_money.initial_value).to eq(100)
        expect(cash.rub_money.income).to eq(10)
        expect(cash.rub_money.income_of_income).to eq(1)
        expect(cash.rub_money.income_of_income_of_income).to eq(0.1)

        expect(cash.usd_money.value).to eq(1111)
        expect(cash.usd_money.initial_value).to eq(1000)
        expect(cash.usd_money.income).to eq(100)
        expect(cash.usd_money.income_of_income).to eq(10)
        expect(cash.usd_money.income_of_income_of_income).to eq(1)

        expect(cash.eur_money.value).to eq(11110)
        expect(cash.eur_money.initial_value).to eq(10000)
        expect(cash.eur_money.income).to eq(1000)
        expect(cash.eur_money.income_of_income).to eq(100)
        expect(cash.eur_money.income_of_income_of_income).to eq(10)
      end
    end
  end
end