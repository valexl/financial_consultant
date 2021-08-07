require 'spec_helper'

RSpec.describe "Investments costs logic" do
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

    context "and there is extra earnings via dividends for this investment" do
      let(:dividend) do
        Investments::Dividend.new(value: 1000, currency: Currency::USD)
      end

      before do
        investment.add_dividend(dividend)
      end

      it "changes amount of invested money by dividend value (return some part of invested money)" do
        expect(investment.invested_money.value.round).to eq(price.value - dividend.value)
      end

      it "increases amount of cash by dividend value" do
        expect(cash.money(Currency::USD).value.round).to eq(11600 + 1000)
      end

      context "and there is price changing that covers all dividend earnings" do
        let(:new_price) { Investments::Price.new(value: 9000, currency: Currency::USD) }

        before do
          investment.change_price(new_price)
        end

        context "investment gest closed" do
          before do
            investment.close
          end

          it "closes investment with zero profit and loss" do
            expect(cash.money(Currency::USD).value.round).to eq(21600)
          end

          it "doesn't change income values" do
            usd_money = cash.money(Currency::USD)
            expect(usd_money.value.round).to eq(21600)
            expect(usd_money.initial_value.round).to eq(20000)
            expect(usd_money.income.round).to eq(1000)
            expect(usd_money.income_of_income.round).to eq(500)
            expect(usd_money.income_of_income_of_income.round).to eq(100)
          end
        end
      end

      context "and there is price changing that gives some income" do
        let(:new_price) { Investments::Price.new(value: 19000, currency: Currency::USD) }

        before do
          investment.change_price(new_price)
        end

        context "investment gest closed" do
          before do
            investment.close
          end

          it "closes investment with profit" do
            expect(cash.money(Currency::USD).value.round).to eq(31600)
          end

          it "changes income values" do
            usd_money = cash.money(Currency::USD)
            expect(usd_money.value.round).to eq(31600)
            expect(usd_money.initial_value.round).to eq(20000)
            expect(usd_money.income).to eq(1000 + 9259.2589)
            expect(usd_money.income_of_income).to eq(500 + 462.963)
            expect(usd_money.income_of_income_of_income).to eq(100 + 277.7779)
          end
        end
      end      
    end
  end
end