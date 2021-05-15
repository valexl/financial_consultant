class Balance
  attr_reader :id, :cash, :investments

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
    stock_investment = StockInvestment.new(name: name, initial_price: price, balance: self)
    stock_investment.open
    stock_investment
  end

  def total_equity(currency)
    cash.value(currency) + investments.sum { |i| i.value(currency) }
  end

  def replenish(money)
    cash.add(money)
  end

  def take(money)
    cash.subtract(money)
  end

  def notify(source, event)
    case event
    when 'investment_opening_request'
      open_investment(source)
    when 'investment_earnings_receiving_request'
      receive_earnings(source)
    when 'investment_costs_reimbursing_request'
      reimburse_costs(source)
    when 'investment_closed'
      close_investment(source)
    when 'profit_taken'
      take_investment_profit(source)
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

  def rub_cash_only_value
    cash.rub_only_value
  end

  def usd_cash_only_value
    cash.usd_only_value
  end

  def eur_cash_only_value
    cash.eur_only_value
  end

  private

  def open_investment(investment)
    return unless cash.enough_money?(investment.price)

    cash.subtract(investment.price)
    investments.push(investment)
  end

  def receive_earnings(earnings)
    cash.add(earnings)
  end

  def reimburse_costs(costs)
    cash.subtract(costs)
  end

  def close_investment(investment)
    cash.add(investment.initial_price)
    cash.add(investment.total_costs) # we received and saved info about costs before but now we need to re-calculate it based on income levels
    cash.subtract(investment.total_earnings) # we received and saved info about earnings before but now we need to re-calculate it based on income levels
    cash.add(investment.net_interest_income)
    @investments -= [investment]
  end

  def take_investment_profit(money)
    cash.add(money)
  end
end
