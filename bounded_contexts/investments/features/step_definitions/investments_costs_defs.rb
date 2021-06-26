When('{float} {string} costs come for this investment') do |costs_value, costs_currency|
  $browser.post '/api/investments/expense', { 
    investment: { 
      name: @investment.name 
    }, 
    expense: {
      currency: costs_currency,
      value: costs_value
    }
  }
end
