module Commands
  class ReplenishBalanceCommand < BaseCommand

    def initialize(balance:, currency:, value:)
      @balance = balance
      money_creator = MoneyCreator.new
      @money = money_creator.build(currency: currency, initial_value: value)
    end

    def execute
      @balance.replenish(@money)
    end
  end
end