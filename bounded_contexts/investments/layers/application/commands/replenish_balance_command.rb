module Commands
  class ReplenishBalanceCommand < BaseCommand

    def initialize(currency:, value:)
      money_creator = MoneyCreator.new
      @money = money_creator.build(currency: currency, value: value)
    end

    def execute(balance)
      balance.replenish(@money)
      balance
    end
  end
end