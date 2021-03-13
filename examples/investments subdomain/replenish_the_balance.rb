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
end

class Balance
  class << self
    def replenish(money)
      instance.replenish(money)
    end

    def instance
      @instance
    end
  end
  
  attr_reader :cash
  def initialize(cash:)
    @cash = cash
  end

  @instance = new(cash: Cash.new)
  private_class_method :new

  def replenish(money)
    cash.add(money)
    puts "value - #{cash.value}"
    # do some logic
  end
end


money = Money.new(value: 100, currency: "RUB")
balance = Balance.replenish(money)
balance = Balance.replenish(money)
balance = Balance.replenish(money)


