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
              total_equity: {
                rub: balance.total_equity(Currency::RUB),
                usd: balance.total_equity(Currency::USD),
                eur: balance.total_equity(Currency::EUR),
              },
              investments: balance.investments.map do |investment|
                {
                  type: investment.type,
                  name: investment.name,
                  price: {
                    currency: investment.price.currency,
                    value: investment.price.value
                  }
                } 
              end
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
                total_equity: {
                  rub: balance.total_equity(Currency::RUB),
                  usd: balance.total_equity(Currency::USD),
                  eur: balance.total_equity(Currency::EUR),
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

              investment = if r.params.dig("investment", "type") == "apartment"
                balance.open_apartment_investment(
                  name: r.params.dig("investment", "name"), 
                  price: money
                )
              elsif r.params.dig("investment", "type") == "stock"
                balance.open_stock_investment(
                  name: r.params.dig("investment", "name"), 
                  price: money
                )
              else
                raise 'Unsupported type'
              end

              Repositories::BalanceRepository.save(balance)
              { 
                investment: {
                  type: investment.type,
                  name: investment.name,
                  price: {
                    currency: investment.price.currency,
                    value: investment.price.value
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