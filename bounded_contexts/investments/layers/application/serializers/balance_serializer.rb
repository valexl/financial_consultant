module Serializers
  class BalanceSerializer
    attr_reader :balance
    def initialize(balance)
      @balance = balance
    end

    def serialize
      {
        balance: { 
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
            Serializers::InvestmentSerializer.new(investment).serialize[:investment]
          end
        }
      }
    end
  end
end