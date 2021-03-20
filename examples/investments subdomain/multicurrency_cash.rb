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
  attr_accessor :value
  attr_reader :currency
  
  def initialize(value:, currency:)
    @value = value
    @currency = currency
  end

  def add(money)
    return self if money.currency != currency
    self.class.new(value: value + money.value, currency: currency)
  end

  def subtract(money)
    return self if money.currency != currency
    self.class.new(value: value - money.value, currency: currency)
  end
end

class Price < Money
end

class Earnings < Money
end

class Costs < Money
end

class MoneyBuilder
  @instance = new
  private_class_method :new

  class << self
    def instance
      @instance
    end
  end

  def build_rub(value: )
    Money.new(value: value, currency: Currency::RUB)
  end

  def build_usd(value: )
    Money.new(value: value, currency: Currency::USD)
  end

  def build_eur(value: )
    Money.new(value: value, currency: Currency::EUR)
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
    @rub_money = @rub_money.add(money)
    @eur_money = @eur_money.add(money)
    @usd_money = @usd_money.add(money)
  end

  def subtract(money)
    @rub_money = @rub_money.subtract(money)
    @eur_money = @eur_money.subtract(money)
    @usd_money = @usd_money.subtract(money)
  end
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
    @cash = cash
    @investments = investments
  end

  def replenish(money)
    cash.add(money)
    puts "cash value - #{cash.value}"
  end

  def take(money)
    cash.subtract(money)
    puts "cash value - #{cash.value}"
  end
end


money_builder = MoneyBuilder.instance
cash = Cash.new(
  default_currency: Currency::RUB, 
  rub_money: money_builder.build_rub(value: 0), 
  usd_money: money_builder.build_usd(value: 0), 
  eur_money: money_builder.build_eur(value: 0), 
)
balance = Balance.init(cash: cash)

money = money_builder.build_usd(value: 1000)
balance.replenish(money)
money = money_builder.build_rub(value: 100000)
balance.replenish(money)
money = money_builder.build_eur(value: 800)
balance.replenish(money)

