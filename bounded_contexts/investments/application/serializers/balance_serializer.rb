module Serializers
  class BalanceSerializer
    attr_reader :balance
    def initialize(balance)
      @balance = balance
    end

    def serialize
      { 
        cash: {
          rub: balance.cash_rub_money_value,
          usd: balance.cash_usd_money_value,
          eur: balance.cash_eur_money_value
        },
        total_equity: {
          rub: balance.total_equity(Currency::RUB),
          usd: balance.total_equity(Currency::USD),
          eur: balance.total_equity(Currency::EUR),
        },
        investments: balance.investments.map do |investment|
          {
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
        end
      }
    end
  end
end