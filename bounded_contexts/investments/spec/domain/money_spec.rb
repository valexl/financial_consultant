require 'spec_helper'

RSpec.describe Money do
  let(:money) { Money.new(currency: currency, items: items) }
  let(:currency) { Currency::USD }
  let(:items) do 
    [
      Money::Item.new(value: initial_value, level: 0),
      Money::Item.new(value: income, level: 1),
      Money::Item.new(value: income_of_income, level: 2),
      Money::Item.new(value: income_of_income_of_income, level: 3)
    ]
  end
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
    
    let(:another_money) { Money.new(currency: another_currency, items: another_items) }
    let(:another_currency) { Currency::USD }
    let(:another_items) do 
      [
        Money::Item.new(value: another_initial_value, level: 0),
        Money::Item.new(value: another_income, level: 1),
        Money::Item.new(value: another_income_of_income, level: 2),
        Money::Item.new(value: another_income_of_income_of_income, level: 3)
      ]
    end
    let(:another_initial_value) { 1000 }
    let(:another_income) { 100 }
    let(:another_income_of_income) { 10 }
    let(:another_income_of_income_of_income) { 1 }

    it {  expect(add).to be_a(Money) }

    it "increases items per level" do
      new_money = add
      expect(new_money.items[0].value).to eq(2000)
      expect(new_money.items[1].value).to eq(200)
      expect(new_money.items[2].value).to eq(20)
      expect(new_money.items[3].value).to eq(2)
    end
  end

  describe "#subtract" do
    subject(:subtract) { money.subtract(another_money) }
    
    let(:another_money) { Money.new(currency: another_currency, items: another_items) }
    let(:another_currency) { Currency::USD }
    let(:another_items) do 
      [
        Money::Item.new(value: another_initial_value, level: 0),
        Money::Item.new(value: another_income, level: 1),
        Money::Item.new(value: another_income_of_income, level: 2),
        Money::Item.new(value: another_income_of_income_of_income, level: 3)
      ]
    end
    let(:another_initial_value) { 1000 }
    let(:another_income) { 100 }
    let(:another_income_of_income) { 10 }
    let(:another_income_of_income_of_income) { 1 }

    it {  expect(subtract).to be_a(Money) }

    it "decreases items per level" do
      new_money = subtract
      expect(new_money.items[0].value).to eq(0)
      expect(new_money.items[1].value).to eq(0)
      expect(new_money.items[2].value).to eq(0)
      expect(new_money.items[3].value).to eq(0)
    end

    context "when another money doesn't have any income and has only initial value" do
      context "and total value of subtrahend is exact the same as minuend" do
        let(:another_initial_value) { 1111 }
        let(:another_income) { 0 }
        let(:another_income_of_income) { 0 }
        let(:another_income_of_income_of_income) { 0 }

        it "takes missed money from the incomes" do
          new_money = subtract
          expect(new_money.items[0].value).to eq(0)
          expect(new_money.items[1].value).to eq(0)
          expect(new_money.items[2].value).to eq(0)
          expect(new_money.items[3].value).to eq(0)
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
            expect(new_money.items[0].value).to eq(100)
            expect(new_money.items[1].value).to eq(100)
            expect(new_money.items[2].value).to eq(10)
            expect(new_money.items[3].value).to eq(1)
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
            expect(new_money.items[0].value).to eq(200)
            expect(new_money.items[1].value).to eq(0)
            expect(new_money.items[2].value).to eq(10)
            expect(new_money.items[3].value).to eq(1)
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
            expect(new_money.items[0].value).to eq(210)
            expect(new_money.items[1].value).to eq(0)
            expect(new_money.items[2].value).to eq(0)
            expect(new_money.items[3].value).to eq(1)
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
            expect(new_money.items[0].value).to eq(0)
            expect(new_money.items[1].value).to eq(0)
            expect(new_money.items[2].value).to eq(0)
            expect(new_money.items[3].value).to eq(1)
          end
        end
      end
    end
  end
end