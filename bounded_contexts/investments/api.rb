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

              Repositories::BalanceRepository.save(balance)
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

        r.on 'investments' do
          r.on 'open' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              money_creator = MoneyCreator.new(MoneyBuilder.new)

              money = money_creator.build(
                currency: r.params.dig("investment", "price", "currency"), 
                value: r.params.dig("investment", "price", "value").to_f
              )

              if r.params.dig("investment", "type")
                apartment_investment = balance.open_apartment_investment(name: "Rental", price: money)
              end

              Repositories::BalanceRepository.save(balance)
              { 
                investment: {
                  type: apartment_investment.type,
                  price: {
                    currency: apartment_investment.price.currency,
                    value: apartment_investment.price.value
                  }
                },
              }
            end
          end
        end
      end
    end
  end
end