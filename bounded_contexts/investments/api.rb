module FinancialConsultant
  module Investments
    class API < Roda
      plugin :json

      route do |r|
        r.on 'balance' do
          r.get true do
            balance = Repositories::BalanceRepository.fetch
            { 
              cash: {
                rub: balance.rub_cash_only_value,
                usd: balance.usd_cash_only_value,
                eur: balance.eur_cash_only_value
              },
              investments: []
            }
          end

          r.on 'replenish' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              money_creator = MoneyCreator.new(MoneyBuilder.new)
              money = money_creator.build(currency: r.params.dig("money", "currency"), value: r.params.dig("money", "value"))
              balance.replenish(money)
              { 
                cash: {
                  rub: balance.rub_cash_only_value,
                  usd: balance.usd_cash_only_value,
                  eur: balance.eur_cash_only_value
                },
                investments: []
              }
            end
          end
        end
      end
    end
  end
end