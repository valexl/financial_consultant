When('{float} {string} costs come for this investment') do |costs_value, costs_currency|
  $browser.post '/api/investments/costs', { 
    investment: { 
      name: @investment.name 
    }, 
    costs: {
      currency: costs_currency,
      value: costs_value
    }
  }
end
