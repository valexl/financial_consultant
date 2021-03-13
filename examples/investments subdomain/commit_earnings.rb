class Money
  attr_accessor :value
  attr_reader :currency
  
  def initialize(value:, currency: "USD")
    @value = value
    @currency = currency
  end
end

class Cash
  attr_reader :money
  def initialize(money=nil)
    @money = money || Money.new(value: 0)
  end

  def value
    money.value
  end

  def add(money)
    @money = Money.new(value: @money.value + money.value, currency: @money.currency)
  end

  def remove(money)
    @money = Money.new(value: @money.value - money.value, currency: @money.currency)
  end
end

class Investment
  attr_reader :name, :initial_price, :price
  def initialize(name:, initial_price:, price: nil)
    @name = name
    @initial_price = initial_price
    @price = price || initial_price
    @earnings = []
    @cosrs = []
  end

  def commit_earnings(money)
    @earnings.push(money)
  end
end

class AppartmentInvestment < Investment
end

class StockInvestment < Investment
end


class Balance
  class << self
    def replenish(money)
      instance.replenish(money)
    end

    def open_investment(investment)
      instance.open_investment(investment)
    end

    def instance
      @instance
    end
  end
  
  attr_reader :cash, :investments
  def initialize(cash:, investments: [])
    @cash = cash
    @investments = investments
  end

  @instance = new(cash: Cash.new)
  private_class_method :new

  def replenish(money)
    cash.add(money)
    puts "cash value - #{cash.value}"
    # do some logic
  end

  def open_investment(investment)
    cash.remove(investment.price)
    investments.push(investment)
    puts "name - #{investment.name}; initial price value - #{investment.initial_price.value}; initial price currency - #{investment.initial_price.currency}"
    puts "investments.count - #{investments.count}"
    puts "cash value - #{cash.value}"
    # do some logic
  end  
end


money = Money.new(value: 10000)
balance = Balance.replenish(money)

money = Money.new(value: 10000)
balance = Balance.replenish(money)

money = Money.new(value: 100)
appartment_investment = AppartmentInvestment.new(name: "Rental", initial_price: money)
Balance.open_investment(appartment_investment)

money = Money.new(value: 2000)
stock_investment = StockInvestment.new(name: "GOOG", initial_price: money)
Balance.open_investment(stock_investment)


money = Money.new(value: 2000)
appartment_investment.commit_earnings(money)
