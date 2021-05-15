module Repositories
  class InvestmentsRepository
    def self.create(investment)
      investment_record = InvestmentRecord.create(
        type: investment.type,
        name: investment.name,
        price_currency: investment.price_currency,
        price_value: investment.price_value,
        balance_id: investment.balance_id
      )
      investment.id = investment_record.id
    end

    private

    def self.investments_table
      DB[:investments]
    end

    class InvestmentRecord <  Sequel::Model(:investments)
    end
  end
end