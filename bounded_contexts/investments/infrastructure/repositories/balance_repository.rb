module Repositories
  class BalanceRepository
    def self.initiate(rub_cash_value: 0, usd_cash_value: 0, eur_cash_value: 0)
      BalanceRecord.create(cash: { "rub" => rub_cash_value,  "usd" => usd_cash_value,  "eur" => eur_cash_value}.to_json)
    end

    def self.fetch
      balace_record = BalanceRecord.last
      cash = JSON.parse(balace_record.cash)
      BalanceFactory.build(
        id: balace_record.id,
        rub_value: cash["rub"].to_f,
        usd_value: cash["usd"].to_f,
        eur_value: cash["eur"].to_f,
      )
    end

    def self.save(balance)
      cash = {
        "rub" => balance.rub_cash_only_value,
        "usd" => balance.usd_cash_only_value,
        "eur" => balance.eur_cash_only_value
      }
      BalanceRecord.where(id: balance.id).update(cash: cash.to_json)
    end

    private

    def self.balance_table
      DB[:balances]
    end

    class BalanceRecord <  Sequel::Model(:balances)
    end


  end
end