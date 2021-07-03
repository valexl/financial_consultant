module Serializers
  class InvestmentSerializer
    attr_reader :investment

    def initialize(investment)
      @investment = investment
    end

    def serialize
      return { status: "skipped" } if investment.nil?
      
      {
        investment: {
          type: investment.type,
          name: investment.name,
          status: investment.status,
          price: {
            currency: investment.price_currency,
            value: investment.price_value
          },
          invested_money: {
            currency: investment.invested_money_currency,
            initial_value: investment.invested_money_initial_value,
            income: investment.invested_money_income,
            income_of_income: investment.invested_money_income_of_income,
            income_of_income_of_income: investment.invested_money_income_of_income_of_income,
          }
        } 
      }
    end
  end
end