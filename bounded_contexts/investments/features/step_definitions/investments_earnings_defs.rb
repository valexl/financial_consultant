Given('opened investment') do
  cash = Cash.new(
    rub_money: $money_creator.build_rub(value: @rub_cash_value),
    usd_money: $money_creator.build_usd(value: @usd_cash_value),
    eur_money: $money_creator.build_eur(value: @eur_cash_value)
  )
  balance = Balance.new(cash: cash, investments: [])
  balance.investments = []
  
  price = $money_creator.build_rub(value: 0)
  @investment = balance.open_apartment_investment(name: 'test', price: price)
  Repositories::BalanceRepository.create(balance)
end

Given('closed investment') do
  cash = Cash.new(
    rub_money: $money_creator.build_rub(value: @rub_cash_value),
    usd_money: $money_creator.build_usd(value: @usd_cash_value),
    eur_money: $money_creator.build_eur(value: @eur_cash_value)
  )
  balance = Balance.new(cash: cash, investments: [])
  balance.investments = []
  
  price = $money_creator.build_rub(value: 0)
  @investment = balance.open_apartment_investment(name: 'test', price: price)
  @investment.close
  Repositories::BalanceRepository.create(balance)
end

When('{float} {string} earnings come from this investment') do |earnings_value, currency|
  $browser.post '/api/investments/earnings', { 
    investment: { 
      name: @investment.name 
    }, 
    earnings: {
      currency: currency,
      value: earnings_value
    }
  }
end


