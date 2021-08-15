require 'spec_helper'

RSpec.describe "Investments profit logic" do
  let(:money_creator) { MoneyCreator.new }
  let(:cash) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: 0),
      usd_money: money_creator.build_usd(
        value: usd_value, 
        initial_value_in_percent: usd_initial_value.to_f/usd_value, 
        income_in_percent: usd_income.to_f/usd_value, 
        income_of_income_in_percent: usd_income_of_income.to_f/usd_value, 
        income_of_income_of_income_in_percent: usd_income_of_income_of_income.to_f/usd_value
      ),
      eur_money: money_creator.build_eur(value: 0)
    )
  end
  let(:usd_value) { usd_initial_value + usd_income + usd_income_of_income + usd_income_of_income_of_income}
  let(:usd_initial_value) { 20000 }
  let(:usd_income) { 1000 }
  let(:usd_income_of_income) { 500 }
  let(:usd_income_of_income_of_income) { 100 }

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
      expect(cash.value(Currency::USD).round).to eq(11600)
    end

    it "keeps a total_equity of balance on the same value as before opening an investment" do
      expect(balance.total_equity(Currency::USD).round).to eq(21600)
    end
    
    context "and price was doubled for this investment" do
      let(:new_price) { Investments::Price.new(value: 2*price.value, currency: Currency::USD) }
      
      before do
        investment.change_price(new_price)
      end

      it "changes a total_equity of balance by the price difference value" do
        expect(balance.total_equity(Currency::USD).round).to eq(31600)
      end

      context "and investment is closed" do
        before do
          investment.close
        end

        it "increases a total_equity of balance on the same value as before opening an investment" do
          expect(balance.total_equity(Currency::USD).round).to eq(31600)
        end
        
        it "increases all levels of income" do
          usd_money = cash.money(Currency::USD)
          expect(usd_money.income).to eq(1000 + 9259.2593)
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
        expect(balance.total_equity(Currency::USD).round).to eq(16600.0)
      end

      context "and investment is closed" do
        before do
          investment.close
        end

        it "decreases a total_equity of balance on the same value as before opening an investment" do
          expect(balance.total_equity(Currency::USD).round).to eq(16600.0)
        end
        
        it "decreases all levels of money" do
          usd_money = cash.money(Currency::USD)

          expect(usd_money.initial_value.round(4)).to eq((20000 - 4629.6296).round(4))
          expect(usd_money.income).to eq(1000 - 231.4815)
          expect(usd_money.income_of_income).to eq(500 - 115.7407)
          expect(usd_money.income_of_income_of_income).to eq(100 - 23.1481)
        end
      end
    end

    context "and dividends covered initial price" do
      let(:dividend) do
        Investments::Dividend.new(value: price.value, currency: Currency::USD)
      end

      before do
        investment.add_dividend(dividend)
      end

      it "changes a total_equity of balance by the dividend value" do
        expect(balance.total_equity(Currency::USD).round).to eq(31600)
      end

      context "and investment is closed" do
        before do
          investment.close
        end

        it "increases a total_equity of balance on the same value as before opening an investment" do
          expect(balance.total_equity(Currency::USD).round).to eq(31600)
        end
        
        it "increases all levels of income" do
          usd_money = cash.money(Currency::USD)
          expect(usd_money.income).to eq(1000 + 9259.2593)
          expect(usd_money.income_of_income).to eq(500 + 462.963)
          expect(usd_money.income_of_income_of_income).to eq(100 + 277.7778)
        end
      end
    end
  end
end