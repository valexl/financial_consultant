require 'spec_helper'

RSpec.describe Repositories::InvestmentsRepository do
  describe ".create" do
    subject(:create) { described_class.create(investment) }

    let(:balance) do 
      cash = Cash.new(
        rub_money: money_creator.build_rub(value: 0),
        usd_money: money_creator.build_usd(value: 0),
        eur_money: money_creator.build_eur(value: 0)
      )
      Balance.new(id: balance_id, cash: cash, investments: [])
    end
    let(:balance_id) { 1 }
    

    let(:new_cash) do
      cash = Cash.new(
        rub_money: money_creator.build_rub(value: 100),
        usd_money: money_creator.build_usd(value: 1000),
        eur_money: money_creator.build_eur(value: 10000)
      )
    end
    let(:investment) do
      Investments::ApartmentInvestment.new(
        name: "Test", 
        initial_price: money_creator.build_usd(value: 200),
        balance: balance
      )
    end
    let(:builder)  { MoneyBuilder.new }
    let(:money_creator) { MoneyCreator.new(builder) }


    it "creates new record in db" do
      expect {
        create
      }.to change { Repositories::InvestmentsRepository::InvestmentRecord.count }.by(1)
    end

    it "creates record with expected attributes" do
      create
      investment_record = Repositories::InvestmentsRepository::InvestmentRecord.last
      expect(investment_record).to have_attributes(
        balance_id: balance_id,
        name: investment.name,
        type: "appartment",
        price_value: investment.price_value,
        price_currency: investment.price_currency,
      )
    end
  end
end