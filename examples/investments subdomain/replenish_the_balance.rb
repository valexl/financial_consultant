class Money
  attr_reader :value, :currency
  def initialize(value:, currency:)
    @value = value
    @currency = currency
  end
end

class Balance
  @instance = new
  private_class_method :new

  def self.replenish(money)
    instance.replenish(money)
  end

  def self.instance
    @instance
  end

  def replenish(money)
    puts "value - #{money.value}, currency - #{money.currency}"
    # do some logic
  end
end


money = Money.new(value: 100, currency: "RUB")
balance = Balance.replenish(money)


