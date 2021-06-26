Given('closed investment') do
  cash = Cash.new(
    rub_money: $money_creator.build_rub(initial_value: @rub_cash_value),
    usd_money: $money_creator.build_usd(initial_value: @usd_cash_value),
    eur_money: $money_creator.build_eur(initial_value: @eur_cash_value)
  )
  balance = Balance.new(cash: cash, investments: [])
  balance.investments = []
  
  investment_creator = InvestmentCreator.new(balance)
  @investment = investment_creator.build(
    name: "test",
    type: "appartment",
    price: {
      "currency" => Currency::RUB,
      "value" => @rub_cash_value
    },
  )
  @investment.open
  @investment.close
  Repositories::BalanceRepository.create(balance)
end

When('{float} {string} dividend comes from this investment') do |dividend_value, currency|
  $browser.post '/api/investments/dividend', { 
    investment: { 
      name: @investment.name 
    }, 
    dividend: {
      currency: currency,
      value: dividend_value
    }
  }
end


