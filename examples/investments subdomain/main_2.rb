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
  attr_reader :items, :initial_value, :income, :income_of_income, :income_of_income_of_income
  
  def initialize(currency:, initial_value: 0, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    @currency = currency
    @initial_value = initial_value
    @income = income
    @income_of_income = income_of_income
    @income_of_income_of_income = income_of_income_of_income
  end

  def to_s
    value.to_s
  end

  def +(money)
    return self if money.currency != currency
    self.class.new(
      currency: currency,
      initial_value: (initial_value + money.initial_value).round(4),
      income: (income + money.income).round(4),
      income_of_income: (income_of_income + money.income_of_income).round(4),
      income_of_income_of_income: (income_of_income_of_income + money.income_of_income_of_income).round(4),
    )
  end

  def -(money)
    return self if money.currency != currency
    self.class.new(
      currency: currency,
      initial_value: (initial_value - money.initial_value).round(4),
      income: (income - money.income).round(4),
      income_of_income: (income_of_income - money.income_of_income).round(4),
      income_of_income_of_income: (income_of_income_of_income - money.income_of_income_of_income).round(4),
    )
  end  

  def exchange(new_currency)
    self.class.new(
      currency: new_currency,
      initial_value: Currency.exchange(initial_value, currency, new_currency),
      income: Currency.exchange(income, currency, new_currency),
      income_of_income: Currency.exchange(income_of_income, currency, new_currency),
      income_of_income_of_income: Currency.exchange(income_of_income_of_income, currency, new_currency),
    )
  end

  def positive?
    value.positive?
  end

  def add(money)
    self + money
  end

  def subtract(money)
    self - money
  end

  def clone(amount)
    given_income_of_income_of_income = (amount * income_of_income_of_income_in_percent).round(4)
    given_income_of_income = (amount * income_of_income_in_percent).round(4)
    given_income = (amount * income_in_percent).round(4)
    given_initial_value = amount - (given_income + given_income_of_income + given_income_of_income_of_income)

    money = self.class.new(
      currency: currency,
      initial_value: given_initial_value,
      income: given_income,
      income_of_income: given_income_of_income,
      income_of_income_of_income: given_income_of_income_of_income,
    )
  end

  def lock_in_profits
    self.class.new(
      currency: currency,
      initial_value: 0,
      income: initial_value,
      income_of_income: income,
      income_of_income_of_income: income_of_income + income_of_income_of_income
    )
  end

  def split(amount)
    money = clone(amount)
    new_money = self - money
    return [new_money, money]
  end

  def value
    initial_value + income + income_of_income + income_of_income_of_income
  end

  def initial_value_in_percent
    (initial_value.to_f/value)
  end

  def income_in_percent
    (income.to_f/value)
  end

  def income_of_income_in_percent
    (income_of_income.to_f/value)
  end

  def income_of_income_of_income_in_percent
    (income_of_income_of_income.to_f/value)
  end
end


#####################################
## Builder to create Money Objects ##
#####################################

class MoneyCreator
  def build(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0, currency:)
    Money.new(
      currency: currency,
      initial_value: initial_value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
    )
  end

  def build_rub(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      initial_value: initial_value, 
      income: income, 
      income_of_income: income_of_income, 
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::RUB
    )
  end

  def build_usd(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      initial_value: initial_value, 
      income: income, 
      income_of_income: income_of_income, 
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::USD
    )
  end

  def build_eur(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      initial_value: initial_value, 
      income: income, 
      income_of_income: income_of_income, 
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::EUR
    )
  end
end

#####################################
#####################################
#####################################


class Cash
  def initialize(rub_money:, eur_money:, usd_money: )
    @rub_money = rub_money
    @eur_money = eur_money
    @usd_money = usd_money
  end

  def value(currency)
    @rub_money.exchange(currency).value + @eur_money.exchange(currency).value + @usd_money.exchange(currency).value
  end

  def add(money)
    @rub_money = @rub_money + money
    @eur_money = @eur_money + money
    @usd_money = @usd_money + money
  end

  def take(value:, currency:)
    case currency
    when @rub_money.currency
      new_money, taken_money = @rub_money.split(value)
      @rub_money = new_money
    when @eur_money.currency
      new_money, taken_money = @eur_money.split(value)
      @eur_money = new_money
    when @usd_money.currency
      new_money, taken_money = @usd_money.split(value)
      @usd_money = new_money
    end
    taken_money
  end
end

#####################################
#####################################
#####################################

class Price 
  attr_reader :value, :currency
  
  def initialize(value:, currency:)
    @value = value
    @currency = currency
  end

  def exchange(new_currency)
    self.class.new(
      currency: new_currency,
      value: Currency.exchange(value, currency, new_currency)
    )
  end
end

class Investment
  attr_reader :name, :price, :invested_money

  def initialize(name:, price:, balance:, invested_money: nil)
    @name = name
    @price = price
    @balance = balance
    @invested_money = invested_money || Money.new(currency: price_currency)
  end

  def price_value
    price.value
  end

  def price_currency
    price.currency
  end

  def value(currency)
    @price.exchange(currency).value
  end

  def invest_money(money)
    @invested_money = @invested_money + money
  end

  def change_price(new_price)
    @price = new_price
  end

  def profit
    invested_money
      .clone(price_value - invested_money.value)
      .lock_in_profits
  end

  def open
    @balance.notify(self, "open_investment")
  end

  def close
    @balance.notify(self, "close_investment")
  end
end

#####################################
#####################################
#####################################


class Balance
  class << self
    def init(cash:, investments: [])
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
    puts "cash value - #{cash.value(Currency::USD)}"
    # do some logic
  end

  def total_equity(currency)
    cash.value(currency) + investments.sum { |i| i.value(currency) }
  end

  def notify(source, event)
    case event
    when "open_investment"
      open_investment(source)
    when "close_investment"
      close_investment(source)
    end
  end

  private

  def open_investment(investment)
    money = cash.take(currency: investment.price_currency, value: investment.price_value)
    investment.invest_money(money)
    @investments.push(investment)
  end

  def close_investment(investment)
    @investments = @investments - [investment]
    @cash.add(investment.invested_money)
    @cash.add(investment.profit)
  end
end

#####################################
#####################################
#####################################

money_creator = MoneyCreator.new
cash = Cash.new(
  rub_money: money_creator.build_rub(initial_value: 0), 
  usd_money: money_creator.build_usd(initial_value: 20000, income: 1000, income_of_income: 500, income_of_income_of_income: 100), 
  eur_money: money_creator.build_eur(initial_value: 0), 
)
balance = Balance.init(cash: cash)

money = money_creator.build_usd(initial_value: 20000)
balance.replenish(money)

puts '************************'
puts "Income of income - #{cash.instance_variable_get(:@usd_money).income_of_income}"
puts '************************'

price = Price.new(value: 10000, currency: Currency::USD)
investment = Investment.new(name: "test", price: price, balance: balance)
investment.open

puts '!!!!!!!!'
puts cash.value(Currency::USD)
puts '!!!!!!!!'
puts balance.total_equity(Currency::USD)
puts '!!!!!!!!'

new_price = Price.new(value: 20000, currency: Currency::USD)
investment.change_price(new_price)
investment.close

puts '?????????'
puts cash.value(Currency::USD)
puts '?????????'
puts balance.total_equity(Currency::USD)
puts '?????????'

puts '************************'
puts "Income of income - #{cash.instance_variable_get(:@usd_money).income_of_income}"
puts '************************'
