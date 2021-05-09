require_relative "replenish_balance_defs"

Given('investment costs {float} {string}') do |investment_cost, currency|
  @investment_price = $money_creator.public_send("build_#{currency.downcase}", value: investment_cost)
end

Given('cash equals {float} RUB') do |cash_value_rub|
  @cash_value_rub = $money_creator.build_rub(value: cash_value_rub)
end

Given('cash equals {float} USD') do |cash_value_usd|
  @cash_value_usd = $money_creator.build_usd(value: cash_value_usd)
end

Given('cash equals {float} EUR') do |cash_value_eur|
  @cash_value_eur = $money_creator.build_eur(value: cash_value_eur)
end

When('opens this investment') do
  balance_cash = Cash.new(
    default_currency: Currency::USD,
    rub_money: @cash_value_rub || $money_creator.build_rub(value: 0),
    usd_money: @cash_value_usd || $money_creator.build_usd(value: 0),
    eur_money: @cash_value_eur || $money_creator.build_eur(value: 0)
  )

  @balance = Balance.init(cash: balance_cash)

  @investment = @balance.open_appartment_investment(name: 'test', price: @investment_price)
end

Then('cash should be {float} {string}') do |expected_value, currency|
  expect(@balance.public_send("#{currency.downcase}_cash_only_value")).to eq(expected_value)
end

Then('new opened investment') do
  expect(@balance.investments).to contain_exactly(@investment)
end

Then('no new investments') do
  expect(@balance.investments).not_to include(@investment)
end

Then('total equity should be {float} RUB') do |expected_value|
  expect(@balance.total_equity(Currency::RUB)).to eq(expected_value)
end

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

Given('opened investment prices {float} {string}') do |investment_price, currency|
  balance_cash = Cash.new(
    default_currency: Currency::USD,
    rub_money: @cash_value_rub || $money_creator.build_rub(value: 0),
    usd_money: @cash_value_usd || $money_creator.build_usd(value: 0),
    eur_money: @cash_value_eur || $money_creator.build_eur(value: 0)
  )

  @balance = Balance.init(cash: balance_cash)
  price = $money_creator.public_send("build_#{currency.downcase}", value: investment_price)
  @investment = @balance.open_appartment_investment(name: 'test', price: price)
end

Given('closed investment prices {float} {string}') do |investment_price, currency|
  balance_cash = Cash.new(
    default_currency: Currency::USD,
    rub_money: @cash_value_rub || $money_creator.build_rub(value: 0),
    usd_money: @cash_value_usd || $money_creator.build_usd(value: 0),
    eur_money: @cash_value_eur || $money_creator.build_eur(value: 0)
  )

  @balance = Balance.init(cash: balance_cash)
  initial_price = $money_creator.public_send("build_#{currency.downcase}", value: 0)
  @investment = @balance.open_appartment_investment(name: 'test', price: initial_price)
  @investment.close

  new_price = $money_creator.public_send("build_#{currency.downcase}", value: investment_price)
  @investment.change_price(new_price)
end

When('investment closing') do
  @investment.close
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
