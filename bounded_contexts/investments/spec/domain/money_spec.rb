require 'spec_helper'

RSpec.describe Money do
  let(:money) do 
    money_creator.build(
      currency: currency, 
      initial_value: initial_value, 
      income: income, 
      income_of_income: income_of_income, 
      income_of_income_of_income: income_of_income_of_income
    )
  end
  let(:money_creator) do
    MoneyCreator.new
  end
  let(:currency) { Currency::USD }
  let(:initial_value) { 1000 }
  let(:income) { 100 }
  let(:income_of_income) { 10 }
  let(:income_of_income_of_income) { 1 }

  describe "#value" do
    subject(:value) { money.value }

    it "returns sum of all items" do
      expect(value).to eq(initial_value + income + income_of_income + income_of_income_of_income)
    end
  end

  describe "#add" do
    subject(:add) { money.add(another_money) }
    
    let(:another_money) do
      money_creator.build(
        currency: another_currency, 
        initial_value: another_initial_value, 
        income: another_income, 
        income_of_income: another_income_of_income, 
        income_of_income_of_income: another_income_of_income_of_income
      )
    end
    let(:another_currency) { Currency::USD }
    let(:another_initial_value) { 1000 }
    let(:another_income) { 100 }
    let(:another_income_of_income) { 10 }
    let(:another_income_of_income_of_income) { 1 }

    it {  expect(add).to be_a(Money) }

    it "increases items per level" do
      new_money = add
      expect(new_money.initial_value).to eq(2000)
      expect(new_money.income).to eq(200)
      expect(new_money.income_of_income).to eq(20)
      expect(new_money.income_of_income_of_income).to eq(2)
    end

    it "doesn't change original object" do
      expect { 
        add
      }.not_to change { money.value }
    end
  end

  describe "#subtract" do
    subject(:subtract) { money.subtract(another_money) }
    
    let(:another_money) do
      money_creator.build(
        currency: another_currency, 
        initial_value: another_initial_value, 
        income: another_income, 
        income_of_income: another_income_of_income, 
        income_of_income_of_income: another_income_of_income_of_income
      )
    end
    let(:another_currency) { Currency::USD }
    let(:another_initial_value) { 1000 }
    let(:another_income) { 100 }
    let(:another_income_of_income) { 10 }
    let(:another_income_of_income_of_income) { 1 }

    it {  expect(subtract).to be_a(Money) }

    it "doesn't change original object" do
      expect { 
        subtract
      }.not_to change { money.value }
    end

    it "changes all levels" do
      new_money = subtract
      expect(new_money.initial_value).to eq(0)
      expect(new_money.income).to eq(0)
      expect(new_money.income_of_income).to eq(0)
      expect(new_money.income_of_income_of_income).to eq(0)
    end

    context "when another money doesn't have any income and has only initial value" do
      context "and total value of subtrahend is exact the same as minuend" do
        let(:another_initial_value) { 1111 }
        let(:another_income) { 0 }
        let(:another_income_of_income) { 0 }
        let(:another_income_of_income_of_income) { 0 }

        it "takes missed money from the incomes" do
          new_money = subtract

          expect(new_money.initial_value).to eq(0)
          expect(new_money.income).to eq(0)
          expect(new_money.income_of_income).to eq(0)
          expect(new_money.income_of_income_of_income).to eq(0)
        end
      end

      context "and total value of subtrahend is less the same as minuend" do
        context "#1" do
          let(:another_initial_value) { 900 }
          let(:another_income) { 0 }
          let(:another_income_of_income) { 0 }
          let(:another_income_of_income_of_income) { 0 }

          it "returns money object with correct value" do
            new_money = subtract
            expect(new_money.value).to eq(money.value - another_money.value)
          end          
  
          it "takes missed money from the incomes" do
            new_money = subtract
            expect(new_money.initial_value).to eq(100)
            expect(new_money.income).to eq(100)
            expect(new_money.income_of_income).to eq(10)
            expect(new_money.income_of_income_of_income).to eq(1)
          end
        end

        context "#2" do
          let(:another_initial_value) { 800 }
          let(:another_income) { 100 }
          let(:another_income_of_income) { 0 }
          let(:another_income_of_income_of_income) { 0 }

          it "returns money object with correct value" do
            new_money = subtract
            expect(new_money.value).to eq(money.value - another_money.value)
          end          
  
          it "takes missed money from the incomes" do
            new_money = subtract
            expect(new_money.initial_value).to eq(200)
            expect(new_money.income).to eq(0)
            expect(new_money.income_of_income).to eq(10)
            expect(new_money.income_of_income_of_income).to eq(1)
          end
        end

        context "#3" do
          let(:another_initial_value) { 700 }
          let(:another_income) { 100 }
          let(:another_income_of_income) { 100 }
          let(:another_income_of_income_of_income) { 0 }

          it "returns money object with correct value" do
            new_money = subtract
            expect(new_money.value).to eq(money.value - another_money.value)
          end

          it "takes missed money from the incomes" do
            new_money = subtract
            expect(new_money.initial_value).to eq(210)
            expect(new_money.income).to eq(0)
            expect(new_money.income_of_income).to eq(0)
            expect(new_money.income_of_income_of_income).to eq(1)
          end
        end
  
        context "#4" do
          let(:income_of_income_of_income) { 2 }
          let(:another_initial_value) { 1001 }
          let(:another_income) { 100 }
          let(:another_income_of_income) { 10 }
          let(:another_income_of_income_of_income) { 0 }

          it "returns money object with correct value" do
            new_money = subtract
            expect(new_money.value).to eq(money.value - another_money.value)
          end          
  
          it "takes missed money from the incomes" do
            new_money = subtract
            expect(new_money.initial_value).to eq(0)
            expect(new_money.income).to eq(0)
            expect(new_money.income_of_income).to eq(0)
            expect(new_money.income_of_income_of_income).to eq(1)
          end
        end
      end
    end
  end

  describe "#clone" do
    subject(:do_clone) { money.clone(given_value) }

    let(:cloned_money) { do_clone }
    let(:given_value) { money.value * 10 }

    it { is_expected.to be_a(Money) }

    it "returns object with value equals given_value" do
      expect(cloned_money.value).to eq(given_value)
    end

    it "generates initial_value, income, income_of_income, income_of_income_of_income with the same proportions as in original object" do
      expect(cloned_money.initial_value).to eq(initial_value * 10)
      expect(cloned_money.income).to eq(income * 10)
      expect(cloned_money.income_of_income).to eq(income_of_income * 10)
      expect(cloned_money.income_of_income_of_income).to eq(income_of_income_of_income * 10)
    end
  end

  describe "#split" do
    subject(:split) { raise 'Implement me' }

    it { is_expected.not_to raise_error }
  end
end