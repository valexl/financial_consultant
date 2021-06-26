require 'spec_helper'

RSpec.describe "Investments profit logic" do
  let(:money_creator) { MoneyCreator.new }
  let(:cash) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(initial_value: 0),
      usd_money: money_creator.build_usd(initial_value: 20000, income: 1000, income_of_income: 500, income_of_income_of_income: 100),
      eur_money: money_creator.build_eur(initial_value: 0)
    )
  end
  let(:balance) do
    Balance.new(cash: cash, investments: [])
  end

  context "when there is new investment" do
    let(:price) { Investments::Price.new(value: 10000, currency: Currency::USD) }
    let(:investment) { Investments::Base.new(name: "test", price: price, balance: balance) }
    before do
      investment.open
    end

    it "decreases amount of cach by investment price value" do
      expect(cash.value(Currency::USD)).to eq(11600)
    end

    it "keeps a total_equity of balance on the same value as before opening an investment" do
      expect(balance.total_equity(Currency::USD)).to eq(21600)
    end
    
    context "and price was doubled for this investment" do
      let(:new_price) { Investments::Price.new(value: 20000, currency: Currency::USD) }
      
      before do
        investment.change_price(new_price)
      end

      it "changes a total_equity of balance by the price difference value" do
        expect(balance.total_equity(Currency::USD)).to eq(31600)
      end

      context "and investment is closed" do
        before do
          investment.close
        end

        it "increases a total_equity of balance on the same value as before opening an investment" do
          expect(balance.total_equity(Currency::USD)).to eq(31600)
        end
        
        it "increases all levels of income" do
          usd_money = cash.money(Currency::USD)
          expect(usd_money.income).to eq(1000 + 9259.2592)
          expect(usd_money.income_of_income).to eq(500 + 462.963)
          expect(usd_money.income_of_income_of_income).to eq(100 + 277.7778)
        end
      end
    end

    context "and price was decreased for this investment" do
      let(:new_price) { Investments::Price.new(value: 5000, currency: Currency::USD) }
      
      before do
        investment.change_price(new_price)
      end

      it "changes a total_equity of balance by the price difference value" do
        expect(balance.total_equity(Currency::USD)).to eq(16600.0)
      end

      context "and investment is closed" do
        before do
          investment.close
        end

        it "decreases a total_equity of balance on the same value as before opening an investment" do
          expect(balance.total_equity(Currency::USD)).to eq(16600.0)
        end
        
        it "decreases all levels of money" do
          usd_money = cash.money(Currency::USD)

          expect(usd_money.initial_value).to eq(20000 - 4629.6295)
          expect(usd_money.income).to eq(1000 - 231.4815)
          expect(usd_money.income_of_income).to eq(500 - 115.7408)
          expect(usd_money.income_of_income_of_income).to eq(100 - 23.1482)
        end
      end
    end

  end
end