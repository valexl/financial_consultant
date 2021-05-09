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
              { result: "OK", body: r.params["params"] }
            end
          end
        end
      end
    end
  end
end