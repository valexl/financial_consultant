module Repositories
  class BalanceRepository
    def self.initiate
      balance = DB[:balances]
      balance.insert(cash: { "rub" => 0,  "usd" => 0,  "eur" => 0 }.to_json)
    end

    def self.fetch(money_creator)
      balance = DB[:balances].order(:id).last

      cash = JSON.parse(balance[:cash])
      BalanceFactory.build(
        rub_value: cash["rub"].to_f,
        usd_value: cash["usd"].to_f,
        eur_value: cash["eur"].to_f,
      )
    end
  end
end