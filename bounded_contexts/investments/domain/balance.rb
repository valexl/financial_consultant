class Balance
  attr_accessor :id, :cash, :investments

  def initialize(id: nil, cash:, investments: [])
    @id = id
    @cash = cash || Cash.new
    @investments = investments
  end

  def open_apartment_investment(name:, price:)
    apartment_investment = Investments::ApartmentInvestment.new(name: name, initial_price: price, balance: self)
    apartment_investment.open
    apartment_investment
  end

  def open_stock_investment(name:, price:)
    stock_investment = Investments::StockInvestment.new(name: name, initial_price: price, balance: self)
    stock_investment.open
    stock_investment
  end

  def find_investment(name:)
    investments.find {|investment| investment.name == name}
  end

  def total_equity(currency)
    cash.value(currency) + investments.sum { |i| i.value(currency) }
  end

  def replenish(money)
    cash.add(money)
  end

  def take(money)
    cash.take(money)
  end

  def notify(source, event)
    case event
    when 'open_investment'
      open_investment(source)
    when 'investment_earnings_receiving_request'
      receive_earnings(source)
    when 'investment_costs_reimbursing_request'
      reimburse_costs(source)
    when 'close_investment'
      close_investment(source)
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

  def rub_cash_money
    cash.rub_money
  end

  def rub_cash_only_value
    rub_cash_money.value
  end

  def usd_cash_money
    cash.usd_money
  end

  def usd_cash_only_value
    usd_cash_money.value
  end

  def eur_cash_money
    cash.eur_money
  end

  def eur_cash_only_value
    eur_cash_money.value
  end

  private

  def open_investment(investment)
    return investment unless cash.enough_money?(investment.price)

    money = cash.take(investment.price)

    investment.add_costs(money)
    investment.mark_opened
    investments.push(investment)

    return investment
  end

  def receive_earnings(earnings)
    cash.add(earnings)
  end

  def reimburse_costs(costs)
    cash.take(costs)
  end

  def close_investment(investment)
    return investment unless investment.opened?
    cash.add(investment.total_costs) # we received and saved info about costs before but now we need to re-calculate it based on income levels
    cash.subtract(investment.total_earnings) # we received and saved info about earnings before but now we need to re-calculate it based on income levels
    cash.add(investment.net_interest_income)
    investment.mark_closed
    @investments -= [investment]

    return investment
  end
end
