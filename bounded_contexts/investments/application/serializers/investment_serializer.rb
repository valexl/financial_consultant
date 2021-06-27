module Serializers
  class InvestmentSerializer
    attr_reader :investment

    def initialize(investment)
      @investment = investment
    end

    def serialize
      {
        investment: {
          type: investment.type,
          name: investment.name,
          status: investment.status,
          price: {
            currency: investment.price.currency,
            value: investment.price.value
          },
          invested_money: {
            currency: investment.invested_money.currency,
            initial_value: investment.invested_money.initial_value,
            income: investment.invested_money.income,
            income_of_income: investment.invested_money.income_of_income,
            income_of_income_of_income: investment.invested_money.income_of_income_of_income,
          }
        } 
      }
    end
  end
end