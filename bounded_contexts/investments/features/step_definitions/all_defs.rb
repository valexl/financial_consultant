require_relative "replenish_balance_defs"
require_relative "investments_defs"
require_relative "investments_earnings_defs"
require_relative "investments_costs_defs"

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
