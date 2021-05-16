require_relative "replenish_balance_defs"
require_relative "investments_defs"

When('{float} RUB earnings come from this investment') do |earnings_value|
  earnings = $money_creator.build_rub(value: earnings_value)
  @investment.receive_earnings(earnings)
end

Given('opened investment') do
  balance_cash = Cash.new(
    default_currency: Currency::USD,
    rub_money: @cash_value_rub || $money_creator.build_rub(value: 0),
    usd_money: @cash_value_usd || $money_creator.build_usd(value: 0),
    eur_money: @cash_value_eur || $money_creator.build_eur(value: 0)
  )

  @balance = Balance.init(cash: balance_cash)

  @investment = @balance.open_appartment_investment(name: 'test', price: $money_creator.build_rub(value: 0))
end

Given('closed investment') do
  balance_cash = Cash.new(
    default_currency: Currency::USD,
    rub_money: @cash_value_rub || $money_creator.build_rub(value: 0),
    usd_money: @cash_value_usd || $money_creator.build_usd(value: 0),
    eur_money: @cash_value_eur || $money_creator.build_eur(value: 0)
  )

  @balance = Balance.init(cash: balance_cash)

  @investment = @balance.open_appartment_investment(name: 'test', price: $money_creator.build_rub(value: 0))
  @investment.close
end

When('{float} RUB costs come for this investment') do |costs_value|
  costs = $money_creator.build_rub(value: costs_value)
  @investment.reimburse_costs(costs)
end

When('investment opening by price {float} RUB') do |investment_price|
  if @balance.blank?
    balance_cash = Cash.new(
      default_currency: Currency::USD,
      rub_money: @cash_value_rub || $money_creator.build_rub(value: 0),
      usd_money: @cash_value_usd || $money_creator.build_usd(value: 0),
      eur_money: @cash_value_eur || $money_creator.build_eur(value: 0)
    )

    @balance = Balance.init(cash: balance_cash)
  end
  price = $money_creator.build_rub(value: investment_price)
  @investment = @balance.open_appartment_investment(name: 'test', price: price)
end

When('investment closing with {float} RUB profit') do |profit|
  current_rub_price = @investment.value(Currency::RUB)
  new_price = $money_creator.build_rub(value: current_rub_price + profit)
  @investment.change_price(new_price)
  @investment.close
end

Then('{float} RUB is withdrawable') do |expected_withdrawable_money_rub|
  expect(@balance.withdrawable_money_rub.value).to eq(expected_withdrawable_money_rub)
end
