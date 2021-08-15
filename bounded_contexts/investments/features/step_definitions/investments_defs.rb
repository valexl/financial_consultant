
Given('opened investment prices {float} {string}') do |investment_price, currency|
  cash = Cash.new(
    rub_money: $money_creator.build_rub(value: @rub_cash_value),
    usd_money: $money_creator.build_usd(value: @usd_cash_value),
    eur_money: $money_creator.build_eur(value: @eur_cash_value)
  )
  balance = Balance.new(cash: cash, investments: [])
  balance.investments = []

  money = $money_creator.public_send("build_#{currency.downcase}", value: investment_price)
  balance.replenish(money)


  investment_creator = InvestmentCreator.new(balance)
  @investment = investment_creator.build(
    name: "test",
    type: "appartment",
    price: {
      "currency" => currency,
      "value" => investment_price
    },
  )
  
  @investment.open
  
  Repositories::BalanceRepository.create(balance)
end

Given('cash equals {float} RUB') do |rub_cash_value|
  @rub_cash_value = rub_cash_value
end

Given('cash equals {float} USD') do |usd_cash_value|
  @usd_cash_value = usd_cash_value
end

Given('cash equals {float} EUR') do |eur_cash_value|
  @eur_cash_value = eur_cash_value
end

Given('closed investment prices {float} {string}') do |investment_price, currency|
  cash = Cash.new(
    rub_money: $money_creator.build_rub(value: @rub_cash_value),
    usd_money: $money_creator.build_usd(value: @usd_cash_value),
    eur_money: $money_creator.build_eur(value: @eur_cash_value)
  )
  balance = Balance.new(cash: cash, investments: [])
  balance.investments = []
  
  investment_creator = InvestmentCreator.new(balance)
  @investment = investment_creator.build(
    name: "test",
    type: "appartment",
    price: {
      "currency" => currency,
      "value" => 0
    },
  )
  @investment.open
  @investment.close

  new_price = Investments::Price.new(currency: currency, value: investment_price)
  @investment.change_price(new_price)
  
  Repositories::BalanceRepository.create(balance)  
end

Given('investment costs {float} {string}') do |investment_cost, currency|
  @investment_cost = OpenStruct.new(currency: currency, value: investment_cost)
end

When('opens this investment') do
  cash = Cash.new(
    rub_money: $money_creator.build_rub(value: @rub_cash_value),
    usd_money: $money_creator.build_usd(value: @usd_cash_value),
    eur_money: $money_creator.build_eur(value: @eur_cash_value)
  )
  balance = Balance.new(cash: cash, investments: [])
  Repositories::BalanceRepository.create(balance)

  $browser.post '/api/investments/open', {
    investment: { 
      type: "apartment", 
      name: "cucumber_test", 
      price: { 
        currency: @investment_cost.currency, 
        value: @investment_cost.value
      } 
    }
  }
end

When('investment closing') do
  $browser.post '/api/investments/close', { investment: { name: @investment.name } }
end

Then('cash should be {float} {string}') do |expected_value, currency|
  response = $browser.get '/api/balance'
  expect(JSON.parse(response.body).dig("balance", "cash", currency.downcase)).to eq(expected_value)
end

Then('new opened investment') do
  response = $browser.get '/api/balance'
  expect(JSON.parse(response.body).dig("balance", "investments").count).to eq(1)
end

Then('no new investments') do
  response = $browser.get '/api/balance'
  expect(JSON.parse(response.body).dig("balance", "investments").count).to eq(0)
end

Then('total equity should be {float} {string}') do |expected_value, currency|
  response = $browser.get '/api/balance'
  expect(JSON.parse(response.body).dig("balance", "total_equity", currency.downcase)).to eq(expected_value)
end
