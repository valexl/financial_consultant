class Cash
  attr_accessor :rub_money
  attr_accessor :usd_money
  attr_accessor :eur_money

  def initialize(rub_money:, eur_money:, usd_money:)
    @rub_money = rub_money
    @eur_money = eur_money
    @usd_money = usd_money
  end

  def value(currency)
    availabile_monies.sum { |availabile_money| availabile_money.exchange(currency).value }
  end

  def add(money)
    return if money.nil?

    strategy = build_currency_based_strategy(money)
    strategy.add(money)
  end

  def subtract(money)
    return if money.nil?
    strategy = build_currency_based_strategy(money)
    strategy.subtract(money)
  end

  def take(money)
    return if money.nil?
    strategy = build_currency_based_strategy(money)
    strategy.take(money)
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

  def build_currency_based_strategy(money)
    klass = self.class.const_get("#{money.currency}Strategy")
    klass.new(self)
  end

  class RUBStrategy
    def initialize(cash)
      @cash = cash
    end

    def add(money)
      new_money = @cash.rub_money.add(money)
      @cash.rub_money = new_money
    end

    def subtract(money)
      new_money = @cash.rub_money.subtract(money)
      @cash.rub_money = new_money
    end

    def take(money)
      new_money = @cash.rub_money.subtract(money)
      taken_money = @cash.rub_money.subtract(new_money)
      @cash.rub_money = new_money
      taken_money
    end
  end

  class USDStrategy
    def initialize(cash)
      @cash = cash
    end

    def add(money)
      new_money = @cash.usd_money.add(money)
      @cash.usd_money = new_money
    end

    def subtract(money)
      new_money = @cash.usd_money.subtract(money)
      @cash.usd_money = new_money
    end

    def take(money)
      new_money = @cash.usd_money.subtract(money)
      taken_money = @cash.usd_money.subtract(new_money)
      @cash.usd_money = new_money
      taken_money
    end
  end

  class EURStrategy
    def initialize(cash)
      @cash = cash
    end

    def add(money)
      new_money = @cash.eur_money.add(money)
      @cash.eur_money = new_money
    end

    def subtract(money)
      new_money = @cash.eur_money.subtract(money)
      @cash.eur_money = new_money
    end

    def take(money)
      new_money = @cash.eur_money.subtract(money)
      taken_money = @cash.eur_money.subtract(new_money)
      @cash.eur_money = new_money
      taken_money
    end
  end

end

