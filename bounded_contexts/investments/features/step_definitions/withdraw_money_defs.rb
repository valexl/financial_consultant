Before('@WithdrawMoney') do
  cash = Cash.new(
    rub_money: $money_creator.build_rub(value: 100_000),
    usd_money: $money_creator.build_usd(value: 100_000),
    eur_money: $money_creator.build_eur(value: 100_000)
  )
  balance = Balance.new(cash: cash, investments: [])
  balance.investments = []
  @investment_name = "cucumber_test"
  
  Repositories::BalanceRepository.create(balance)
end

When('investment opening by price {float} {string}') do |investment_price, currency|
  @investment_details = OpenStruct.new(name: @investment_name, currency: currency, value: investment_price)
  $browser.post '/api/investments/open', {
    investment: { 
      type: "apartment", 
      name: @investment_details.name, 
      price: { 
        currency: @investment_details.currency, 
        value: @investment_details.value
      } 
    }
  }
end

When('investment closing with {float} {string} profit') do |profit, currency|
  new_price = Investments::Price.new(currency: @investment_details.currency, value: @investment_details.value + profit)

  # TODO: add change price api endpoint
  balance = Repositories::BalanceRepository.fetch
  investment = balance.find_investment(name: @investment_details.name)
  investment.change_price(new_price)
  Repositories::BalanceRepository.save(balance)

  $browser.post '/api/investments/close', { investment: { name: @investment_name } }
end

Then('{float} RUB is withdrawable') do |expected_withdrawable_money_rub|
  balance = Repositories::BalanceRepository.fetch
  expect(balance.withdrawable_money("RUB").value).to eq(expected_withdrawable_money_rub)
end
