require 'spec_helper'

RSpec.describe Repositories::BalanceRepository do
  let(:money_creator) { MoneyCreator.new }
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

    before do
      described_class.create(balance)
    end

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
          rub_money: money_creator.build_rub(
            value: rub_value, 
            initial_value_in_percent: rub_initial_value.to_f/rub_value, 
            income_in_percent: rub_income.to_f/rub_value, 
            income_of_income_in_percent: rub_income_of_income.to_f/rub_value, 
            income_of_income_of_income_in_percent: rub_income_of_income_of_income.to_f/rub_value
          ),
          usd_money: money_creator.build_usd(
            value: usd_value, 
            initial_value_in_percent: usd_initial_value.to_f/usd_value, 
            income_in_percent: usd_income.to_f/usd_value, 
            income_of_income_in_percent: usd_income_of_income.to_f/usd_value, 
            income_of_income_of_income_in_percent: usd_income_of_income_of_income.to_f/usd_value
          ),
          eur_money: money_creator.build_eur(
            value: eur_value, 
            initial_value_in_percent: eur_initial_value.to_f/eur_value, 
            income_in_percent: eur_income.to_f/eur_value, 
            income_of_income_in_percent: eur_income_of_income.to_f/eur_value, 
            income_of_income_of_income_in_percent: eur_income_of_income_of_income.to_f/eur_value

          )
        )
      end
      let(:rub_value) { rub_initial_value + rub_income + rub_income_of_income + rub_income_of_income_of_income}
      let(:rub_initial_value) { 100 }
      let(:rub_income) { 10 }
      let(:rub_income_of_income) { 1 }
      let(:rub_income_of_income_of_income) { 0.1 }

      let(:usd_value) { usd_initial_value + usd_income + usd_income_of_income + usd_income_of_income_of_income}
      let(:usd_initial_value) { 1000 }
      let(:usd_income) { 100 }
      let(:usd_income_of_income) { 10 }
      let(:usd_income_of_income_of_income) { 1 }

      let(:eur_value) { eur_initial_value + eur_income + eur_income_of_income + eur_income_of_income_of_income}
      let(:eur_initial_value) { 10000 }
      let(:eur_income) { 1000 }
      let(:eur_income_of_income) { 100 }
      let(:eur_income_of_income_of_income) { 10 }

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