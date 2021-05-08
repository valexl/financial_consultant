module Repositories
  class BalanceRepository
    def self.initiate
      balance = DB[:balances]
      balance.insert
    end
  end
end