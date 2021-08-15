require 'spec_helper'

RSpec.describe Money do
  let(:money) do 
    money_creator.build(
      currency: currency, 
      value: value,
      initial_value_in_percent: initial_value_in_percent, 
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent
    )
  end
  let(:money_creator) do
    MoneyCreator.new
  end
  let(:currency) { Currency::USD }
  let(:value) { initial_value + income + income_of_income + income_of_income_of_income }
  let(:initial_value) { 1000 }
  let(:income) { 100 }
  let(:income_of_income) { 10 }
  let(:income_of_income_of_income) { 1 }
  let(:initial_value_in_percent) { initial_value.to_f / value }
  let(:income_in_percent) { income.to_f / value }
  let(:income_of_income_in_percent) { income_of_income.to_f / value }
  let(:income_of_income_of_income_in_percent) { income_of_income_of_income.to_f / value }

  describe "#value" do
    it "returns sum of all items" do
      expect(money.value ).to eq(value)
    end
  end

  describe "#add" do
    subject(:add) { money.add(another_money) }
    
    let(:another_money) do
      money_creator.build(
        currency: another_currency, 
        value: another_value, 
        initial_value_in_percent: another_initial_value_in_percent,
        income_in_percent: another_income_in_percent, 
        income_of_income_in_percent: another_income_of_income_in_percent, 
        income_of_income_of_income_in_percent: another_income_of_income_of_income_in_percent
      )
    end
    let(:another_currency) { Currency::USD }
    let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
    let(:another_initial_value) { 2000 }
    let(:another_income) { 100 }
    let(:another_income_of_income) { 10 }
    let(:another_income_of_income_of_income) { 1 }
    let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value}
    let(:another_income_in_percent) { another_income.to_f / another_value }
    let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
    let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


    it {  expect(add).to be_a(Money) }

    it "increases items per level" do
      new_money = add
      expect(new_money.initial_value).to eq(3000)
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
        value: another_value, 
        initial_value_in_percent: another_initial_value_in_percent,
        income_in_percent: another_income_in_percent, 
        income_of_income_in_percent: another_income_of_income_in_percent, 
        income_of_income_of_income_in_percent: another_income_of_income_of_income_in_percent
      )
    end
    let(:another_currency) { Currency::USD }
    let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
    let(:another_initial_value) { 1000 }
    let(:another_income) { 100 }
    let(:another_income_of_income) { 10 }
    let(:another_income_of_income_of_income) { 1 }
    let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value}
    let(:another_income_in_percent) { another_income.to_f / another_value }
    let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
    let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


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
        let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
        let(:another_initial_value) { 1111 }
        let(:another_income) { 0 }
        let(:another_income_of_income) { 0 }
        let(:another_income_of_income_of_income) { 0 }
        let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value }
        let(:another_income_in_percent) { another_income.to_f / another_value }
        let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
        let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


        it "takes missed money from the incomes" do
          new_money = subtract

          expect(new_money.initial_value).to eq(0)
          expect(new_money.income).to eq(0)
          expect(new_money.income_of_income).to eq(0)
          expect(new_money.income_of_income_of_income).to eq(0)
        end
      end

      context "and total value of subtrahend is less than minuend" do
        context "#1" do
          let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
          let(:another_initial_value) { 900 }
          let(:another_income) { 0 }
          let(:another_income_of_income) { 0 }
          let(:another_income_of_income_of_income) { 0 }
          let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value }
          let(:another_income_in_percent) { another_income.to_f / another_value }
          let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
          let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


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
          let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
          let(:another_initial_value) { 800 }
          let(:another_income) { 100 }
          let(:another_income_of_income) { 0 }
          let(:another_income_of_income_of_income) { 0 }
          let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value }
          let(:another_income_in_percent) { another_income.to_f / another_value }
          let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
          let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


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
          let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
          let(:another_initial_value) { 700 }
          let(:another_income) { 100 }
          let(:another_income_of_income) { 100 }
          let(:another_income_of_income_of_income) { 0 }
          let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value }
          let(:another_income_in_percent) { another_income.to_f / another_value }
          let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
          let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


          it "returns money object with correct value" do
            new_money = subtract
            expect(new_money.value).to eq(money.value - another_money.value)
          end

          it "takes missed money from the incomes" do
            new_money = subtract
            expect(new_money.initial_value).to eq(211)
            expect(new_money.income).to eq(0)
            expect(new_money.income_of_income).to eq(0)
            expect(new_money.income_of_income_of_income).to eq(0)
          end
        end
  
        context "#4" do
          let(:income_of_income_of_income) { 2 }
          let(:another_value) { another_initial_value + another_income + another_income_of_income + another_income_of_income_of_income }
          let(:another_initial_value) { 1001 }
          let(:another_income) { 100 }
          let(:another_income_of_income) { 10 }
          let(:another_income_of_income_of_income) { 0 }
          let(:another_initial_value_in_percent) { another_initial_value.to_f / another_value }
          let(:another_income_in_percent) { another_income.to_f / another_value }
          let(:another_income_of_income_in_percent) { another_income_of_income.to_f / another_value }
          let(:another_income_of_income_of_income_in_percent) { another_income_of_income_of_income.to_f / another_value }


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
    subject(:split) { money.split(splited_value) }

    let(:initial_value) { 10000 }
    let(:income) { 1000 }
    let(:income_of_income) { 100 }
    let(:income_of_income_of_income) { 10 }


    let(:splited_value) { 1000 }

    it { is_expected.to be_a(Array) }

    it "returns an array of Money" do
      money1, money2 = split
      expect(money1).to be_a(Money)
      expect(money2).to be_a(Money)
    end

    it "returns moneies with the same total value as original" do
      money1, money2 = split
      expect(money1.value + money2.value).to eq(money.value)
    end

    it "returns monies with the same proportion as original money" do
      money1, money2 = split
      expect(money1.initial_value).to eq(9099.91)
      expect(money1.income).to eq(909.991)
      expect(money1.income_of_income).to eq(90.9991)
      expect(money1.income_of_income_of_income).to eq(9.0999)
    end
  end
end