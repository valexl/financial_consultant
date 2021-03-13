class Money
  attr_reader :value, :currency
  def initialize(value:, currency:)
    @value = value
    @currency = currency
  end
end

class Investment
  attr_reader :name, :initial_price
  def initialize(name:, initial_price:)
    @name = name
    @initial_price = initial_price
  end
end

class AppartmentInvestment < Investment
end

class StockInvestment < Investment
end

class Balance
  class << self
    def open_investment(investment)
      instance.open_investment(investment)
    end

    def instance
      @instance
    end
  end

  attr_reader :assets
  def initialize(assets:)
    @assets = []
  end

  @instance = new(assets: [])

  def open_investment(investment)
    assets.push(investment)
    puts "name - #{investment.name}; initial price value - #{investment.initial_price.value}; initial price currency - #{investment.initial_price.currency}"
    puts "assets.count - #{assets.count}"
    # do some logic
  end
end

money = Money.new(value: 100, currency: "EUR")
investment = AppartmentInvestment.new(name: "Rental", initial_price: money)
Balance.open_investment(investment)

money = Money.new(value: 2000, currency: "USD")
investment = AppartmentInvestment.new(name: "GOOG", initial_price: money)
Balance.open_investment(investment)


