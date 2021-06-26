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

  def notify(event, *args)
    case event
    when "open_investment"
      open_investment(*args)
    when "close_investment"
      close_investment(*args)
    when "add_expense"
      add_expense(*args)
    when "add_dividend"
      add_dividend(*args)
    end
  end

  private

  def open_investment(investment)
    money = cash.take(currency: investment.price_currency, value: investment.price_value)
    investment.invest_money(money)
    @investments.push(investment)
    investment.mark_opened
  rescue Money::NotEnoughMoney
    false
  end

  def close_investment(investment)
    @investments = @investments - [investment]
    @cash.add(investment.invested_money)
    @cash.add(investment.profit)
    @cash.subtract(investment.loss)
    investment.mark_closed
  end

  def add_expense(investment, expense)
    money = cash.take(currency: expense.currency, value: expense.value)
    investment.invest_money(money)
  end

  def add_dividend(investment, dividend)
    invested_money, money = investment.invested_money.split(dividend.value)
    investment.invested_money = invested_money
    cash.add(money)
  end
end
