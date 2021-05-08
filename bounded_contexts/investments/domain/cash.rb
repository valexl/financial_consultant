class Cash
  def initialize(rub_money:, eur_money:, usd_money:)
    @rub_money = rub_money
    @eur_money = eur_money
    @usd_money = usd_money
  end

  def value(currency)
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

