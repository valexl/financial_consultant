require "byebug"

class Currency
  USD = "USD".freeze
  EUR = "EUR".freeze
  RUB = "RUB".freeze

  EXCHANGE_RATES = {
    USD => {
      RUB => 75,
      EUR => 0.8,
      USD => 1
    },
    EUR => {
      RUB => 89,
      EUR => 1,
      USD => 0.8
    },
    RUB => {
      RUB => 1,
      EUR => 0.11,
      USD => 0.13
    }
  }.freeze

  def self.exchange(value, source_currency, destination_currency)
    value * EXCHANGE_RATES[source_currency][destination_currency]
  end
end

class Money
  attr_accessor :currency
  attr_reader :items
  
  def initialize
    @currency = nil
    @items = [
      Item.new(value: 0, level: 1),
      Item.new(value: 0, level: 2),
      Item.new(value: 0, level: 3),
      Item.new(value: 0, level: 4),
    ]
  end

  def add(money)
    return self if money.currency != currency
    result = []
    SumMoneyItemIterator.new(@items, money.items).each do |item1, item2|
      result << Item.new(value: item1.value + item2.value, level: item1.level)
    end
    @items = result
  end

  def subtract(money)
    return self if money.currency != currency
    items = @items.each_with_index.map do |item, index|
      item.value -= money.items[index].value
    end
  end

  def initial_value=(value)
    @items[0].value = value
  end

  def income=(value)
    @items[1].value = value
  end

  def income_of_income=(value)
    @items[2].value = value
  end

  def income_of_income_of_income=(value)
    @items[3].value = value
  end

  def value
    items.map(&:value).sum
  end

  class Item
    attr_reader :value, :level
    attr_writer :value
    
    def initialize(value:, level:)
      @value = value
      @level = level
    end
  end
end

class Price < Money
end

class Earnings < Money
end

class Costs < Money
end

#####################################
## Builder to create Money Objects ##
#####################################

class MoneyBuilder
  MONEY_CLASS = Money

  attr_writer :value, :currency, :percent_of_income, :percent_of_income_of_income, :percent_of_income_of_income_of_income
  def initialize
    reset
  end

  def reset
    @value = 0
    @currency = nil
    @percent_of_income = 0
    @percent_of_income_of_income = 0
    @percent_of_income_of_income_of_income = 0
    @money_object = self.class::MONEY_CLASS.new
  end

  def money_object
    income = @value * @percent_of_income/100.0
    income_of_income = @value * @percent_of_income_of_income/100.0
    income_of_income_of_income = @value * @percent_of_income_of_income_of_income/100.0
    initial_value = @value - income - income_of_income - income_of_income_of_income
    @money_object.currency = @currency
    @money_object.initial_value = initial_value
    @money_object.income = income
    @money_object.income_of_income = income_of_income
    @money_object.income_of_income_of_income = income_of_income_of_income
    @money_object
  end

end

class PriceBuilder < MoneyBuilder
  MONEY_CLASS = Price
end

class EarningsBuilder < MoneyBuilder
  MONEY_CLASS = Earnings
end

class CostsBuilder < MoneyBuilder
  MONEY_CLASS = Costs
end

class MoneyCreator
  attr_accessor :builder
  
  def initialize(builder)
    @builder = builder
  end

  def build(value:, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0, currency:)
    builder.value = value
    builder.currency = currency
    builder.percent_of_income = income_in_percent
    builder.percent_of_income_of_income = income_of_income_in_percent
    builder.percent_of_income_of_income_of_income = income_of_income_of_income_in_percent
    result = builder.money_object
    builder.reset
    result
  end

  def build_rub(value:, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0)
    build(
      value: value, 
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
      currency: Currency::RUB
    )
  end

  def build_usd(value:, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0)
    build(
      value: value, 
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
      currency: Currency::USD
    )
  end

  def build_eur(value:, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0)
    build(
      value: value, 
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
      currency: Currency::EUR
    )
  end
end


#####################################
#####################################
#####################################


class SumMoneyItemIterator
  include Enumerable

  def initialize(first_items, second_items)
    @first_items = first_items
    @second_items = second_items
  end

  def each(&block)
    @first_items.each_with_index do |first_item, index|
      yield first_item, @second_items[index]
    end
  end
end


class Cash
  attr_reader :default_currency
  def initialize(default_currency:, rub_money:, eur_money:, usd_money: )
    @default_currency = default_currency
    @rub_money = rub_money
    @eur_money = eur_money
    @usd_money = usd_money
  end

  def value(currency = default_currency)
    [
      Currency.exchange(@rub_money.value, @rub_money.currency, currency),
      Currency.exchange(@eur_money.value, @eur_money.currency, currency),
      Currency.exchange(@usd_money.value, @usd_money.currency, currency),
    ].sum
  end

  def add(money)
    @rub_money.add(money)
    @eur_money.add(money)
    @usd_money.add(money)
  end

  def subtract(money)
    @rub_money.subtract(money)
    @eur_money.subtract(money)
    @usd_money.subtract(money)
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

  def reimburse_costs(costs)
    @balance.notify(costs, "costs_reimbursed")
  end

  def close
    @balance.notify(self, "investment_closed")
  end

  def change_price(price)
    @price = price
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

  def take(money)
    cash.subtract(money)
    puts "cash value - #{cash.value}"
  end

  def notify(source, event)
    case event
    when "investment_opened"
      open_investment(source)
    when "earnings_received"
      receive_earnings(source)
    when "costs_reimbursed"
      reimburse_costs(source)
    when "investment_closed"
      close_investment(source)
    end
  end

  private

  def open_investment(investment)
    cash.subtract(investment.price)
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

  def reimburse_costs(costs)
    cash.subtract(costs)
    puts "costs value - #{costs.value};"
    puts "cash value - #{cash.value}"
  end

  def close_investment(investment)
    cash.add(investment.price)
    @investments = @investments - [investment]
    puts "investments.count - #{investments.count}"
    puts "cash value - #{cash.value}"
  end
end



money_creator = MoneyCreator.new(MoneyBuilder.new)

cash = Cash.new(
  default_currency: Currency::RUB, 
  rub_money: money_creator.build_rub(value: 0), 
  usd_money: money_creator.build_usd(value: 0), 
  eur_money: money_creator.build_eur(value: 0), 
)

balance = Balance.init(cash: cash)

money = money_creator.build_usd(value: 1000)
balance.replenish(money)

money_creator.builder = PriceBuilder.new

money = money_creator.build_usd(value: 9000)
apartment_investment = ApartmentInvestment.new(name: "Rental", initial_price: money, balance: balance)
apartment_investment.open

money_creator.builder = CostsBuilder.new
costs = money_creator.build_usd(value: 200)
apartment_investment.reimburse_costs(costs)


money_creator.builder = EarningsBuilder.new
earnings = money_creator.build_usd(value: 300)
apartment_investment.receive_earnings(earnings)

money_creator.builder = PriceBuilder.new
price = money_creator.build_usd(value: 9500)
apartment_investment.change_price(price)

apartment_investment.close
