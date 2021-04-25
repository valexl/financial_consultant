require 'byebug'

class Currency
  USD = 'USD'.freeze
  EUR = 'EUR'.freeze
  RUB = 'RUB'.freeze

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

  def initialize(currency: nil, items: nil)
    @currency = currency
    @items = items
    @items ||= [
      Item.new(value: 0, level: 1),
      Item.new(value: 0, level: 2),
      Item.new(value: 0, level: 3),
      Item.new(value: 0, level: 4)
    ]
  end

  def to_s
    value.to_s
  end

  def +(other)
    return self if other.currency != currency

    result = []
    items_iterator.each_with_level do |item1, level|
      result << Item.new(value: item1.value + other.items[level].value, level: level)
    end
    new_money = self.class.new(currency: currency)
    new_money.set_items(result)
    new_money
  end

  def -(other)
    return self if other.currency != currency

    result = []
    items_iterator.each_with_level do |item1, level|
      result << Item.new(value: item1.value - other.items[level].value, level: level)
    end
    new_money = self.class.new(currency: currency)
    new_money.set_items(result)
    new_money
  end

  def >=(other)
    return false if other.currency != currency

    value >= other.value
  end

  def <(other)
    return false if other.currency != currency

    value < other.value
  end

  def positive?
    value.positive?
  end

  def exchange(new_currency)
    result = []
    items_iterator.each_with_level do |item, level|
      new_value = Currency.exchange(item.value, currency, new_currency)
      result << Item.new(value: new_value, level: level)
    end
    money = self.class.new
    money.currency = new_currency
    money.set_items(result)
    money
  end

  def add(money)
    return self if money.currency != currency
    return self unless money.positive?

    result = []
    items_iterator.each_with_level do |item, level|
      result << Item.new(value: item.value + money.items[level].value, level: level)
    end
    @items = result
  end

  def subtract(money)
    return self if money.currency != currency
    return self unless money.positive?
    return self if self < money

    result = []
    items_iterator.each_with_level do |item, level|
      result << Item.new(value: item.value - money.items[level].value, level: level)
    end
    @items = result
  end

  def withdrawable
    money = self.class.new
    money.currency = currency
    money.income_of_income_of_income = withdrawable_items_iterator.sum { |item| item.value }
    money
  end

  def convert_to_the_same_proportion(money)
    new_money = self.class.new(currency: currency)
    new_money.income_of_income_of_income = value * money.income_of_income_of_income_in_percent
    new_money.income_of_income = value * money.income_of_income_in_percent
    new_money.income = value * money.income_in_percent
    new_money.initial_value = value - new_money.income_of_income_of_income - new_money.income_of_income - new_money.income
    new_money
  end

  def move_all_to_one_level
    new_money = self.class.new(currency: currency)
    new_money.initial_value = 0
    new_money.income = initial_value
    new_money.income_of_income = income
    new_money.income_of_income_of_income = value - new_money.value
    new_money
  end

  def set_items(new_items)
    @items = new_items
  end

  def initial_value
    @items[0].value
  end

  def initial_value=(value)
    @items[0].value = value
  end

  def income=(value)
    @items[1].value = value
  end

  def income
    @items[1].value
  end

  def income_of_income=(value)
    @items[2].value = value
  end

  def income_of_income
    @items[2].value
  end

  def income_of_income_of_income=(value)
    @items[3].value = value
  end

  def income_of_income_of_income
    @items[3].value
  end

  def value
    items.map(&:value).sum
  end

  def initial_value_in_percent
    (initial_value.to_f / value)
  end

  def income_in_percent
    (income.to_f / value)
  end

  def income_of_income_in_percent
    (income_of_income.to_f / value)
  end

  def income_of_income_of_income_in_percent
    (income_of_income_of_income.to_f / value)
  end

  private

  def items_iterator
    ItemsIterator.new(@items)
  end

  def withdrawable_items_iterator
    WithdrawableItemsIterator.new(@items)
  end

  class Item
    attr_accessor :value
    attr_reader :level

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

  attr_writer :value, :currency, :income, :income_of_income, :income_of_income_of_income

  def initialize
    reset
  end

  def reset
    @value = 0
    @currency = nil
    @income = 0
    @income_of_income = 0
    @income_of_income_of_income = 0
    @money_object = self.class::MONEY_CLASS.new
  end

  def money_object
    @money_object.currency = @currency
    @money_object.initial_value = @value - @income - @income_of_income - @income_of_income_of_income
    @money_object.income = @income
    @money_object.income_of_income = @income_of_income
    @money_object.income_of_income_of_income = @income_of_income_of_income
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

  def build(value:, currency:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    builder.value = value
    builder.currency = currency
    builder.income = income
    builder.income_of_income = income_of_income
    builder.income_of_income_of_income = income_of_income_of_income
    result = builder.money_object
    builder.reset
    result
  end

  def build_rub(value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      value: value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::RUB
    )
  end

  def build_usd(value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      value: value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::USD
    )
  end

  def build_eur(value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      value: value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::EUR
    )
  end
end

#####################################
#########     Iterators     #########
#####################################

class ItemsIterator
  include Enumerable

  def initialize(items)
    @items = items
  end

  def each(&block)
    @items.each(&block)
  end

  alias each_with_level each_with_index
end

class WithdrawableItemsIterator
  include Enumerable

  def initialize(items)
    @items = items
  end

  def each(&block)
    @items.select { |item| item.level >= 4 }.each(&block)
  end
end

#####################################
#####################################
#####################################

class Cash
  attr_reader :default_currency

  def initialize(default_currency:, rub_money:, eur_money:, usd_money:)
    @default_currency = default_currency
    @rub_money = rub_money
    @eur_money = eur_money
    @usd_money = usd_money
  end

  def value(currency = default_currency)
    availabile_monies.sum { |availabile_money| availabile_money.exchange(currency).value }
  end

  def rub_only_value
    @rub_money.value
  end

  def eur_only_value
    @eur_money.value
  end

  def usd_only_value
    @usd_money.value
  end

  def add(money)
    return if money.nil?

    availabile_monies.each { |availabile_money| availabile_money.add(money) }
  end

  def subtract(money)
    return if money.nil?

    availabile_monies.each { |availabile_money| availabile_money.subtract(money) }
  end

  def withdrawable_money_rub
    @rub_money.withdrawable
  end

  def withdrawable_money_usd
    @usd_money.withdrawable
  end

  def withdrawable_money_eur
    @eur_money.withdrawable
  end

  def enough_money?(money)
    availabile_monies.any? { |availabile_money| availabile_money >= money }
  end

  private

  def availabile_monies
    [
      @rub_money,
      @eur_money,
      @usd_money
    ]
  end
end

#####################################
#####################################
#####################################

class Investment
  attr_reader :name, :initial_price, :price, :total_earnings, :total_costs

  def initialize(name:, initial_price:, balance:, price: nil)
    @name = name
    @initial_price = initial_price
    @price = price || initial_price
    ############
    ## TODO: avoid using direct creation. This is a hotfix
    ############
    @total_earnings = Money.new(currency: initial_price.currency)
    @total_costs = Money.new(currency: initial_price.currency)
    ############
    ############
    @balance = balance
    @status = nil
  end

  def value(currency)
    @price.exchange(currency).value
  end

  def open
    @balance.notify(self, 'investment_opening_request')
    @status = 'opened'
  end

  def receive_earnings(earnings)
    return if @status == 'closed'

    @total_earnings = if @total_earnings.nil?
                        earnings
                      else
                        @total_earnings + earnings
                      end
    @balance.notify(earnings, 'investment_earnings_receiving_request')
  end

  def reimburse_costs(costs)
    return if @status == 'closed'

    @total_costs += costs
    @balance.notify(costs, 'investment_costs_reimbursing_request')
  end

  def close
    @balance.notify(self, 'investment_closed')
    @status = 'closed'
  end

  def change_price(price)
    @price = price
  end

  def take_profit
    price = @price.convert_to_the_same_proportion(@initial_price)
    delta_price = price - @initial_price
    delta_price = delta_price.move_all_to_one_level if delta_price.positive?
    change_price(delta_price)
    @balance.notify(delta_price, 'profit_taken')
  end

  def delta_price
    price = @price.convert_to_the_same_proportion(@initial_price)
    result = price - @initial_price
    result = result.move_all_to_one_level if result.positive?
    result
  end

  # https://en.wikipedia.org/wiki/Net_interest_income
  def net_interest_income
    price = @price.convert_to_the_same_proportion(@initial_price)

    total_earnings = @total_earnings.convert_to_the_same_proportion(@initial_price)
    total_costs = @total_costs.convert_to_the_same_proportion(@initial_price)

    delta_earnings = total_earnings - total_costs
    delta_earnings = delta_earnings.move_all_to_one_level if delta_earnings.positive?

    delta_price + delta_earnings
  end
end

class ApartmentInvestment < Investment
end

class StockInvestment < Investment
end

#####################################
#####################################
#####################################

class Balance
  class << self
    def init(cash: Cash.new, investments: [])
      send(:new, cash: cash, investments: investments)
    end
  end
  private_class_method :new

  attr_reader :cash, :investments

  def initialize(cash:, investments: [])
    @cash = cash || Cash.new
    @investments = investments
  end

  def open_appartment_investment(name:, price:)
    apartment_investment = ApartmentInvestment.new(name: name, initial_price: price, balance: self)
    apartment_investment.open
    apartment_investment
  end

  def open_stock_investment(name:, price:)
    stock_investment = StockInvestment.new(name: name, initial_price: price, balance: self)
    stock_investment.open
    stock_investment
  end

  def total_equity(currency)
    cash.value(currency) + investments.sum { |i| i.value(currency) }
  end

  def replenish(money)
    cash.add(money)
  end

  def take(money)
    cash.subtract(money)
  end

  def notify(source, event)
    case event
    when 'investment_opening_request'
      open_investment(source)
    when 'investment_earnings_receiving_request'
      receive_earnings(source)
    when 'investment_costs_reimbursing_request'
      reimburse_costs(source)
    when 'investment_closed'
      close_investment(source)
    when 'profit_taken'
      take_investment_profit(source)
    end
  end

  def withdrawable_money_rub
    cash.withdrawable_money_rub
  end

  def withdrawable_money_usd
    cash.withdrawable_money_usd
  end

  def withdrawable_money_eur
    cash.withdrawable_money_eur
  end

  def withdraw(money)
    cash.subtract(money)
  end

  def rub_cash_only_value
    cash.rub_only_value
  end

  def usd_cash_only_value
    cash.usd_only_value
  end

  def eur_cash_only_value
    cash.eur_only_value
  end

  private

  def open_investment(investment)
    return unless cash.enough_money?(investment.price)

    cash.subtract(investment.price)
    investments.push(investment)
  end

  def receive_earnings(earnings)
    cash.add(earnings)
  end

  def reimburse_costs(costs)
    cash.subtract(costs)
  end

  def close_investment(investment)
    cash.add(investment.initial_price)
    cash.add(investment.total_costs) # we received and saved info about costs before but now we need to re-calculate it based on income levels
    cash.subtract(investment.total_earnings) # we received and saved info about earnings before but now we need to re-calculate it based on income levels
    cash.add(investment.net_interest_income)
    @investments -= [investment]
  end

  def take_investment_profit(money)
    cash.add(money)
  end
end

class BalanceRepository
  @instance = new

  private_class_method :new

  class << self
    attr_reader :instance
  end

  def fetch_balance(money_creator)
    cash = Cash.new(
      default_currency: Currency::USD,
      rub_money: money_creator.build_rub(value: 0),
      usd_money: money_creator.build_usd(value: 20_000, income: 1000, income_of_income: 500,
                                         income_of_income_of_income: 100),
      eur_money: money_creator.build_eur(value: 0)
    )
    Balance.init(cash: cash)
  end
end
