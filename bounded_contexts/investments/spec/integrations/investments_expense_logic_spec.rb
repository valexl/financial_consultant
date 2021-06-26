require 'spec_helper'

RSpec.describe "Investments costs logic" do
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

    context "and there is extra costs for this investment" do
      let(:expense) do
        Investments::Expense.new(value: 1000, currency: Currency::USD)
      end

      before do
        investment.add_expense(expense)
      end

      it "increases amount of invested money by expense value" do
        expect(investment.invested_money.value).to eq(price.value + expense.value)
      end

      it "decrease amount of cash by expense value" do
        expect(cash.money(Currency::USD).value).to eq(10600)
      end

      context "and there is price changing that covers all expenses" do
        let(:new_price) { Investments::Price.new(value: 11000, currency: Currency::USD) }

        before do
          investment.change_price(new_price)
        end

        context "investment gest closed" do
          before do
            investment.close
          end

          it "closes investment with zero profit and loss" do
            expect(cash.money(Currency::USD).value).to eq(21600)
          end

          it "doesn't change income values" do
            usd_money = cash.money(Currency::USD)
            expect(usd_money.initial_value).to eq(20000)
            expect(usd_money.income).to eq(1000)
            expect(usd_money.income_of_income).to eq(500)
            expect(usd_money.income_of_income_of_income).to eq(100)
          end
        end
      end

      context "and there is price changing that gives some income" do
        let(:new_price) { Investments::Price.new(value: 21000, currency: Currency::USD) }

        before do
          investment.change_price(new_price)
        end

        context "investment gest closed" do
          before do
            investment.close
          end

          it "closes investment with profit" do
            expect(cash.money(Currency::USD).value).to eq(31600)
          end

          it "changes income values" do
            usd_money = cash.money(Currency::USD)
            expect(usd_money.initial_value).to eq(20000)
            expect(usd_money.income).to eq(1000 + 9259.2592)
            expect(usd_money.income_of_income).to eq(500 + 462.963)
            expect(usd_money.income_of_income_of_income).to eq(100 + 277.7778)
          end
        end
      end      
    end
  end
end