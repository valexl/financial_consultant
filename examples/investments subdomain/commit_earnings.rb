class Money
  attr_accessor :value
  attr_reader :currency
  
  def initialize(value:, currency: "USD")
    @value = value
    @currency = currency
  end
end

class Price < Money
end

class Earnings < Money
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

  def initialize(name:, initial_price:, price: nil, balance: )
    @name = name
    @initial_price = initial_price
    @price = price || initial_price
    @balance = balance
  end

  def open
    @balance.notify(self, "investment_opened")
  end

  def receive_earnings(earnings)
    @balance.notify(earnings, "earnings_received")
  end
end

class ApartmentInvestment < Investment
end

class StockInvestment < Investment
end


class Balance
  class << self
    def init(cash: Cash.new, investments: [])
      @instance ||= send(:new, cash: cash, investments: investments)     
    end

    def instance
      @instance
    end
  end
  private_class_method :new
  
  attr_reader :cash, :investments
  
  def initialize(cash:, investments: [])
    @cash = cash || Cash.new
    @investments = investments
  end

  def replenish(money)
    cash.add(money)
    puts "cash value - #{cash.value}"
    # do some logic
  end

  def notify(source, event)
    case event
    when "investment_opened"
      open_investment(source)
    when "earnings_received"
      receive_earnings(source)
    end
  end

  private

  def open_investment(investment)
    cash.remove(investment.price)
    investments.push(investment)
    puts "name - #{investment.name}; initial price value - #{investment.initial_price.value}; initial price currency - #{investment.initial_price.currency}"
    puts "investments.count - #{investments.count}"
    puts "cash value - #{cash.value}"
    # do some logic
  end

  def receive_earnings(earnings)
    cash.add(earnings)
    puts "earnings value - #{earnings.value};"
    puts "cash value - #{cash.value}"
  end
end


balance = Balance.init(cash: Cash.new)
money = Money.new(value: 10000)
balance.replenish(money)

money = Price.new(value: 9000, currency: "USD")
apartment_investment = ApartmentInvestment.new(name: "Rental", initial_price: money, balance: balance)
apartment_investment.open

money = Price.new(value: 100, currency: "USD")
stock_investment = StockInvestment.new(name: "GOOG", initial_price: money, balance: balance)
stock_investment.open

earnings = Earnings.new(value: 2000)
apartment_investment.receive_earnings(earnings)

