class Balance
  attr_accessor :id, :cash, :investments

  def initialize(id: nil, cash:, investments: [])
    @id = id
    @cash = cash
    @investments = investments
  end

  def replenish(money)
    cash.add(money)
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
