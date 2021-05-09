Given('money is {float} {string}') do |value, currency|
  @replenished_money = OpenStruct.new(currency: currency, value: value)
end

When('balance RUB cash is {float}') do |rub_cash_value|
  @rub_cash_value = rub_cash_value
end

When('balance USD cash is {float}') do |usd_cash_value|
  @usd_cash_value = usd_cash_value
end

When('balance EUR cash is {float}') do |eur_cash_value|
  @eur_cash_value = eur_cash_value
end

When('balance is replenished by given money') do
  options = {
    rub_cash_value: @rub_cash_value,
    usd_cash_value: @usd_cash_value,
    eur_cash_value: @eur_cash_value
  }
  Repositories::BalanceRepository.initiate(**options)
  $browser.post '/api/balance/replenish', money: { currency: @replenished_money.currency, value: @replenished_money.value}
end

Then('balance RUB cash should be {float}') do |value|
  response = $browser.get '/api/balance', money: { currency: @replenished_money.currency, value: @replenished_money.value}
  expect(JSON.parse(response.body).dig("cash", "rub")).to eq(value)
end

Then('balance EUR cash should be {float}') do |value|
  response = $browser.get '/api/balance', money: { currency: @replenished_money.currency, value: @replenished_money.value}
  expect(JSON.parse(response.body).dig("cash", "eur")).to eq(value)
end

Then('balance USD cash should be {float}') do |value|
  response = $browser.get '/api/balance', money: { currency: @replenished_money.currency, value: @replenished_money.value}
  expect(JSON.parse(response.body).dig("cash", "usd")).to eq(value)
end