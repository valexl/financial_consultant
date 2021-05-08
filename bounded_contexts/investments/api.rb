module FinancialConsultant
  module Investments
    class API < Roda
      plugin :json

      route do |r|
        r.on 'balance' do
          r.get true do
            { result: "OK" }
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