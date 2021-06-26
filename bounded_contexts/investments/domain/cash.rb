class Cash
  attr_reader :rub_money, :eur_money, :usd_money
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

  def subtract(money)
    @rub_money = @rub_money - money
    @eur_money = @eur_money - money
    @usd_money = @usd_money - money
  end

  def money(currency)
    case currency
    when @rub_money.currency
      @rub_money
    when @eur_money.currency
      @eur_money
    when @usd_money.currency
      @usd_money
    else
      raise 'Unsupported currency'
    end
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
    else
      raise 'Unsupported currency'
    end
    taken_money
  end
end